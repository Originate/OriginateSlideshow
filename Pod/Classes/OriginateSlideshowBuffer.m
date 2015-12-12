//
//  OriginateSlideshowBuffer.m
//  Originate
//
//  Created by Allen Wu on 6/2/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateSlideshowBuffer.h"

@interface OriginateSlideshowBuffer () <OriginateSlideDelegate>

@property (nonatomic, weak) OriginateSlideshowViewController* slideshow;
@property (nonatomic, weak) id<OriginateSlideshowDataSource> dataSource;

@property (nonatomic, strong) NSMutableSet* remainingDownloads;
@property (nonatomic, assign) NSUInteger lastSlideIndex;

@end

@implementation OriginateSlideshowBuffer

- (instancetype)initWithSlideshow:(OriginateSlideshowViewController *)slideshow
                       dataSource:(id<OriginateSlideshowDataSource>)dataSource
{
    self = [super init];
    if (self) {
        _slideshow = slideshow;
        _dataSource = dataSource;
    }
    return self;
}

- (void)bufferStartingAtIndex:(NSUInteger)index
                     duration:(NSTimeInterval)duration
{
    [self.delegate slideshowBufferingDidBegin:self];
    
    NSUInteger numberOfSlidesToFillDuration = [self numberOfSlidesToFillDuration:duration startingAtIndex:index];
    NSUInteger numberOfSlidesToLoad = MIN(self.lastSlideIndex - index + 1, numberOfSlidesToFillDuration);
    
    self.remainingDownloads = [NSMutableSet set];
    
    for (NSUInteger i = index; i < index + numberOfSlidesToLoad; i++) {
        id<OriginateSlide> slide = [self.dataSource slideshow:self.slideshow slideAtIndex:i];
        
        if ([slide canPreload]) {
            slide.delegate = self;
            [slide loadIntoView:nil];
            
            [self.remainingDownloads addObject:slide];
        }
    }
    
    // finish immediately if nothing to buffer
    if (self.remainingDownloads.count == 0) {
        [self.delegate slideshowBufferingDidFinish:self];
    }
    
    NSLog(@"Buffering %lu slides starting at index %lu", (unsigned long)self.remainingDownloads.count, (unsigned long)index);
}


#pragma mark - OriginateSlideDelegate

- (void)slideDidFinishLoading:(id<OriginateSlide>)slide
{
    [self.remainingDownloads removeObject:slide];
    
    if (self.remainingDownloads.count == 0) {
        [self.delegate slideshowBufferingDidFinish:self];
    }
}


#pragma mark - Helpers

- (NSUInteger)numberOfSlidesToFillDuration:(NSTimeInterval)duration
                           startingAtIndex:(NSUInteger)startIndex
{
    NSTimeInterval cumulativeDuration = 0;
    NSUInteger unbufferableSlides = 0;
    NSUInteger i = MIN(startIndex, self.lastSlideIndex);
    
    for (; i <= self.lastSlideIndex; i++) {
        id<OriginateSlide> slide = [self.dataSource slideshow:self.slideshow slideAtIndex:i];
        NSTimeInterval slideDuration = [self.dataSource slideshow:self.slideshow durationForSlideAtIndex:i];
        
        cumulativeDuration += [slide conformsToProtocol:@protocol(OriginateSlideIntrinsicPlayback)] ? [(id<OriginateSlideIntrinsicPlayback>)slide duration] : slideDuration;
        unbufferableSlides += ![slide canPreload] ? 1 : 0;
        
        if (cumulativeDuration >= duration) {
            break;
        }
    }
    
    return i - startIndex - unbufferableSlides + 1;
}

- (NSUInteger)lastSlideIndex
{
    if (_lastSlideIndex == 0) {
        _lastSlideIndex = [self.dataSource numberOfSlidesInSlideshow:self.slideshow] - 1;
    }
    return _lastSlideIndex;
}

@end
