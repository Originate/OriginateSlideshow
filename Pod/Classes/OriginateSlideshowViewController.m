//
//  OriginateSlideshowViewController.m
//  Originate
//
//  Created by Allen Wu on 5/21/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateSlideshowViewController.h"
#import "OriginateSlideshowView.h"
#import "OriginateSlideshowBuffer.h"

@interface OriginateSlideshowViewController () <OriginateSlideDelegate,
                                                OriginateSlideshowBufferDelegate>

// buffering
@property (nonatomic, strong) OriginateSlideshowBuffer* initialBuffer;
@property (nonatomic, strong) OriginateSlideshowBuffer* dynamicBuffer;

// indexing
@property (nonatomic, strong, readonly) id<OriginateSlide> currentSlide;
@property (nonatomic, assign) NSInteger currentSlideIndex;
@property (nonatomic, assign) NSUInteger lastSlideIndex;

// timing
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) NSTimeInterval timeRemainingAfterPause;

// slideshow state
@property (nonatomic, assign, getter = isReady) BOOL ready;
@property (nonatomic, assign, getter = isPlaying) BOOL playing;

// actions
@property (nonatomic, strong) UITapGestureRecognizer* slideshowTapRecognizer;

@property (nonatomic, strong) OriginateSlideshowView* view;

@end

@implementation OriginateSlideshowViewController

@dynamic view;

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[OriginateSlideshowView alloc] init];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view.playPauseView addGestureRecognizer:self.slideshowTapRecognizer];
    [self.view.dismissSlideshowButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.controlsView.restartButton addTarget:self action:@selector(restartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.controlsView.backButton addTarget:self action:@selector(advanceToPreviousSlide) forControlEvents:UIControlEventTouchUpInside];
    [self.view.controlsView.nextButton addTarget:self action:@selector(advanceToNextSlide) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view.spinner startAnimating];
}


#pragma mark - Public methods

- (void)resume
{
    if (!self.isReady) {
        [self.initialBuffer bufferStartingAtIndex:0 duration:6];
    }
    else {
        [self playOrPause];
    }
}


#pragma mark - Setters

- (void)setCurrentSlideIndex:(NSInteger)index
{
    _currentSlideIndex = MAX(0, index);
    
    if (_currentSlideIndex > self.lastSlideIndex) {
        [self finishedSlideshow];
        return;
    }
    
    [self setCurrentSlide:[self.dataSource slideshow:self slideAtIndex:_currentSlideIndex]];
    [self.dynamicBuffer bufferStartingAtIndex:(index+1) duration:[self.dataSource bufferDurationAmountForSlideshow:self]];
    
    [self.view.controlsView.progressView setProgress:[self progress] animated:YES];
}

- (void)setCurrentSlide:(id<OriginateSlide>)slide
{
    [_currentSlide prepareForDismissal];
    
    _currentSlide = slide;
    
    slide.delegate = self;
    
    Class requiredContainerViewClass = [slide requiredContainerViewClass];
    if (requiredContainerViewClass == [UIImageView class]) {
        [slide loadIntoView:self.view.photoContainerView];
    }
    else if (requiredContainerViewClass == [UIView class]) {
        [slide loadIntoView:self.view.videoContainerView];
    }
}

- (void)setPlaying:(BOOL)playing
{
    if (playing != _playing) {
        self.view.playPauseView.state = playing ? OriginateSlideshowPlaybackStatePlaying : OriginateSlideshowPlaybackStatePaused;
        
        _playing = playing;
    }
}


#pragma mark - Properties

- (OriginateSlideshowBuffer *)initialBuffer
{
    if (!_initialBuffer) {
        _initialBuffer = [[OriginateSlideshowBuffer alloc] initWithSlideshow:self dataSource:self.dataSource];
        _initialBuffer.delegate = self;
    }
    return _initialBuffer;
}

- (OriginateSlideshowBuffer *)dynamicBuffer
{
    if (!_dynamicBuffer) {
        _dynamicBuffer = [[OriginateSlideshowBuffer alloc] initWithSlideshow:self dataSource:self.dataSource];
        _dynamicBuffer.delegate = self;
    }
    return _dynamicBuffer;
}

- (UITapGestureRecognizer *)slideshowTapRecognizer
{
    if (!_slideshowTapRecognizer) {
        _slideshowTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideshowTapped:)];
        _slideshowTapRecognizer.numberOfTapsRequired = 1;
    }
    return _slideshowTapRecognizer;
}


#pragma mark - <OriginateSlideshowBufferDelegate>

- (void)slideshowBufferingDidBegin:(OriginateSlideshowBuffer *)buffer
{
    if (buffer == self.initialBuffer) {
        NSLog(@"begin initial slideshow buffering");
        [self.view.spinner startAnimating];
    }
}

- (void)slideshowBufferingDidFinish:(OriginateSlideshowBuffer *)buffer
{
    if (buffer == self.initialBuffer) {
        NSLog(@"finished initial slideshow buffering");
        [self.view.spinner stopAnimating];
        
        self.ready = YES;
        [self play];
    }
}


#pragma mark - <OriginateSlideDelegate>

- (void)slideDidBeginLoading:(id<OriginateSlide>)slide
{
    [self.view.spinner startAnimating];
    
    Class requiredContainerViewClass = [slide requiredContainerViewClass];
    if (requiredContainerViewClass == [UIImageView class]) {
        self.view.photoContainerView.hidden = NO;
        self.view.videoContainerView.hidden = YES;
    }
    else {
        self.view.photoContainerView.hidden = YES;
        self.view.videoContainerView.hidden = NO;
    }
}

- (void)slideDidBeginPresenting:(id<OriginateSlide>)slide
{
    [self.view.spinner stopAnimating];
}

- (void)slideDidFinishLoading:(id<OriginateSlide>)slide
{
    [self.view.spinner stopAnimating];
}

- (void)slideDidFinishPresenting:(id<OriginateSlide>)slide
{
    if ([slide conformsToProtocol:@protocol(OriginateSlideIntrinsicPlayback)]) {
        [self advanceToNextSlide];
    }
    else {
        if (self.isPlaying) {
            NSTimeInterval duration = [self.dataSource slideshow:self durationForSlideAtIndex:self.currentSlideIndex];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                          target:self
                                                        selector:@selector(advanceToNextSlide)
                                                        userInfo:nil
                                                         repeats:NO];
        }
    }
}


#pragma mark - Playback

- (void)advanceToNextSlide
{
    self.currentSlideIndex++;
}

- (void)advanceToPreviousSlide
{
    self.currentSlideIndex--;
}

- (void)finishedSlideshow
{
    if ([self.dataSource slideshowShouldAutomaticallyDismissWhenFinished:self]) {
        [self reset];
        [self.delegate slideshowIsFinished:self];
        [self.delegate slideshowIsDismissed:self];
    }
}

- (void)reset
{
    [self.view.controlsView fadeAwayWithDelay:3];
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.currentSlideIndex = 0;
}

- (void)play
{
    self.playing = YES;
    
    // first time playing
    if (!self.currentSlide) {
        self.currentSlideIndex = 0;
    }
    
    // resume from pause
    else {
        if ([self.currentSlide conformsToProtocol:@protocol(OriginateSlideIntrinsicPlayback)]) {
            [(id<OriginateSlideIntrinsicPlayback>)self.currentSlide play];
        }
        else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeRemainingAfterPause
                                                          target:self
                                                        selector:@selector(advanceToNextSlide)
                                                        userInfo:nil
                                                         repeats:NO];
        }
    }
    
    NSLog(@"[OriginateSlideshow] play");
}

- (void)pause
{
    self.playing = NO;
    
    if ([self.currentSlide conformsToProtocol:@protocol(OriginateSlideIntrinsicPlayback)]) {
        [(id<OriginateSlideIntrinsicPlayback>)self.currentSlide pause];
        
        NSLog(@"[OriginateSlideshow] paused video");
    }
    else {
        self.timeRemainingAfterPause = [self.timer.fireDate timeIntervalSinceNow];
        [self.timer invalidate];
        self.timer = nil;
        
        NSLog(@"[OriginateSlideshow] paused photo (%.2f sec remaining)", self.timeRemainingAfterPause);
    }
}


#pragma mark - Controls

- (void)slideshowTapped:(UITapGestureRecognizer *)sender
{
    if (self.isReady) {
        [self playOrPause];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.view.controlsView.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             if (self.isPlaying) {
                                 [self.view.controlsView fadeAwayWithDelay:3];
                             }
                             else {
                                 [self.view.controlsView show];
                             }
                         }];
    }
}

- (void)playOrPause
{
    self.isPlaying ? [self pause] : [self play];
}

- (void)dismissButtonPressed:(UIButton *)sender
{
    [self reset];
    [self.delegate slideshowIsDismissed:self];
}

- (void)restartButtonPressed:(UIButton *)sender
{
    [self reset];
    [self play];
}


#pragma mark - Helpers

- (CGFloat)progress
{
    return (float)(self.currentSlideIndex + 1) / (self.lastSlideIndex + 1);
}

- (NSUInteger)lastSlideIndex
{
    if (_lastSlideIndex == 0) {
        _lastSlideIndex = [self.dataSource numberOfSlidesInSlideshow:self] - 1;
    }
    return _lastSlideIndex;
}

@end
