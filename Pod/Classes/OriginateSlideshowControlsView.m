//
//  OriginateSlideshowControlsView.m
//  Originate
//
//  Created by Allen Wu on 5/28/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateSlideshowControlsView.h"

@interface OriginateSlideshowControlsView ()

@property (nonatomic, strong) UIView* controlContainerView;
@property (nonatomic, strong) CAGradientLayer* gradientLayer;
@property (nonatomic, strong) NSTimer* fadeTimer;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation OriginateSlideshowControlsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


#pragma mark - Fade

- (void)fadeAwayWithDelay:(NSTimeInterval)delay
{
    [self.fadeTimer invalidate];
    self.fadeTimer = nil;
    
    self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(fade) userInfo:nil repeats:NO];
}

- (void)fade
{
    [UIView animateWithDuration:0.5
                          delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 0;
                     } completion:nil];
}

- (void)show
{
    self.alpha = 1;
    
    [self.fadeTimer invalidate];
    self.fadeTimer = nil;
}


#pragma mark - Layout

- (void)setupView
{
    [self.controlContainerView addSubview:self.restartButton];
    [self.controlContainerView addSubview:self.backButton];
    [self.controlContainerView addSubview:self.nextButton];
    [self.controlContainerView addSubview:self.progressView];
    
    [self addSubview:self.controlContainerView];
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        NSDictionary* subviews = NSDictionaryOfVariableBindings(_backButton,
                                                                _nextButton,
                                                                _restartButton,
                                                                _controlContainerView,
                                                                _progressView);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_controlContainerView]|" options:0 metrics:nil views:subviews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_controlContainerView]|" options:0 metrics:nil views:subviews]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_restartButton(30)]-10-[_backButton(30)]-10-[_progressView]-10-[_nextButton(30)]-50-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:subviews]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.controlContainerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.controlContainerView.bounds;
}


#pragma mark - Subviews

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        _backButton.showsTouchWhenHighlighted = YES;
        _backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"◀\uFE0E◀\uFE0E" forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
        _nextButton.showsTouchWhenHighlighted = YES;
        _nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitle:@"▶\uFE0E▶\uFE0E" forState:UIControlStateNormal];
    }
    return _nextButton;
}

- (UIButton *)restartButton
{
    if (!_restartButton) {
        _restartButton = [[UIButton alloc] init];
        _restartButton.showsTouchWhenHighlighted = YES;
        _restartButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
        [_restartButton setTitle:@"↺" forState:UIControlStateNormal];
        [_restartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _restartButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _restartButton;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.backgroundColor = [UIColor whiteColor];
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
        _progressView.progress = 0;
    }
    return _progressView;
}

- (UIView *)controlContainerView
{
    if (!_controlContainerView) {
        _controlContainerView = [[UIView alloc] init];
        _controlContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [_controlContainerView.layer addSublayer:self.gradientLayer];
    }
    return _controlContainerView;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
        _gradientLayer.locations = @[@0, @0.6];
    }
    return _gradientLayer;
}

@end
