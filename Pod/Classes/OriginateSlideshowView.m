//
//  OriginateSlideshowView.m
//  Originate
//
//  Created by Allen Wu on 5/27/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateSlideshowView.h"

@interface OriginateSlideshowView ()

@property (nonatomic, strong) UITapGestureRecognizer* playPauseTapRecognizer;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation OriginateSlideshowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


#pragma mark - Layout

- (void)setupView
{
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.photoContainerView];
    [self addSubview:self.videoContainerView];
    [self addSubview:self.spinner];
    [self addSubview:self.playPauseView];
    [self addSubview:self.dismissSlideshowButton];
    [self addSubview:self.controlsView];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        NSDictionary* subviews = NSDictionaryOfVariableBindings(_photoContainerView,
                                                                _videoContainerView,
                                                                _dismissSlideshowButton,
                                                                _playPauseView,
                                                                _controlsView);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_dismissSlideshowButton(30)]" options:0 metrics:nil views:subviews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_dismissSlideshowButton(30)]-25-|" options:0 metrics:nil views:subviews]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_photoContainerView]|" options:0 metrics:nil views:subviews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_photoContainerView]|" options:0 metrics:nil views:subviews]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_videoContainerView]|" options:0 metrics:nil views:subviews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_videoContainerView]|" options:0 metrics:nil views:subviews]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_playPauseView]|" options:0 metrics:nil views:subviews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_playPauseView]|" options:0 metrics:nil views:subviews]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_controlsView(70)]|" options:0 metrics:nil views:subviews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_controlsView]|" options:0 metrics:nil views:subviews]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}


#pragma mark - Subviews

- (UIImageView *)photoContainerView
{
    if (!_photoContainerView) {
        _photoContainerView = [[UIImageView alloc] init];
        _photoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        _photoContainerView.contentMode = UIViewContentModeScaleAspectFill;
        _photoContainerView.clipsToBounds = YES;
        _photoContainerView.backgroundColor = [UIColor darkGrayColor];
        _photoContainerView.hidden = YES;
    }
    return _photoContainerView;
}

- (UIView *)videoContainerView
{
    if (!_videoContainerView) {
        _videoContainerView = [[UIView alloc] init];
        _videoContainerView.backgroundColor = [UIColor redColor];
        _videoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        _videoContainerView.hidden = YES;
    }
    return _videoContainerView;
}

- (UIButton *)dismissSlideshowButton
{
    if (!_dismissSlideshowButton) {
        _dismissSlideshowButton = [[UIButton alloc] init];
        _dismissSlideshowButton.translatesAutoresizingMaskIntoConstraints = NO;
        _dismissSlideshowButton.showsTouchWhenHighlighted = YES;
        _dismissSlideshowButton.titleLabel.font = [UIFont systemFontOfSize:40];
        [_dismissSlideshowButton setTitle:@"×" forState:UIControlStateNormal];
        [_dismissSlideshowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _dismissSlideshowButton;
}

- (UIActivityIndicatorView *)spinner
{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.translatesAutoresizingMaskIntoConstraints = NO;
        _spinner.hidesWhenStopped = YES;
        _spinner.userInteractionEnabled = NO;
        [_spinner stopAnimating];
    }
    return _spinner;
}

- (OriginateSlideshowPlayPauseView *)playPauseView
{
    if (!_playPauseView) {
        _playPauseView = [[OriginateSlideshowPlayPauseView alloc] init];
        _playPauseView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _playPauseView;
}

- (OriginateSlideshowControlsView *)controlsView
{
    if (!_controlsView) {
        _controlsView = [[OriginateSlideshowControlsView alloc] init];
        _controlsView.translatesAutoresizingMaskIntoConstraints = NO;
        _controlsView.alpha = 0;
    }
    return _controlsView;
}

@end
