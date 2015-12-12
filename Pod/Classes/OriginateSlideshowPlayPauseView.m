//
//  OriginateSlideshowPlayPauseView.m
//  Originate
//
//  Created by Allen Wu on 5/28/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateSlideshowPlayPauseView.h"

@interface OriginateSlideshowPlayPauseView ()

@property (nonatomic, strong) UIView* iconView;
@property (nonatomic, strong) UILabel* playIcon;
@property (nonatomic, strong) UILabel* pauseIcon;
@property (nonatomic, strong) NSLayoutConstraint* sizeConstraint;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation OriginateSlideshowPlayPauseView

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
    self.state = OriginateSlideshowPlaybackStatePlaying;
    
    self.alpha = 0.8;
    
    [self addSubview:self.iconView];
    [self.iconView addSubview:self.playIcon];
    [self.iconView addSubview:self.pauseIcon];
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        // size
        self.sizeConstraint = [NSLayoutConstraint constraintWithItem:self.iconView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:80];
        [self addConstraint:self.sizeConstraint];
        
        // width = height
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.iconView
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                          constant:0]];
        
        
        // centerX iconViewContainer
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        
        // centerY iconViewContainer
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
        
        // centerX playIcon, offset 3
        [self.iconView addConstraint:[NSLayoutConstraint constraintWithItem:self.playIcon
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.iconView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:3]];
        
        // centerY playIcon
        [self.iconView addConstraint:[NSLayoutConstraint constraintWithItem:self.playIcon
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.iconView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:0]];
        
        // centerX pauseIcon
        [self.iconView addConstraint:[NSLayoutConstraint constraintWithItem:self.pauseIcon
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.iconView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0]];
        
        // centerY pauseIcon, offset -5
        [self.iconView addConstraint:[NSLayoutConstraint constraintWithItem:self.pauseIcon
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.iconView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:-4]];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}


#pragma mark - Subviews

- (UIView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIView alloc] init];
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconView.backgroundColor = [UIColor blackColor];
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.shadowColor = [UIColor blackColor].CGColor;
        _iconView.layer.shadowRadius = 5;
        _iconView.layer.shadowOpacity = 0.5;
    }
    return _iconView;
}

- (UILabel *)playIcon
{
    if (!_playIcon) {
        _playIcon = [[UILabel alloc] init];
        _playIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _playIcon.textColor = [UIColor whiteColor];
        _playIcon.font = [UIFont fontWithName:@"Helvetica" size:40];
        _playIcon.text = @"\U000025B6\U0000FE0E";
    }
    return _playIcon;
}

- (UILabel *)pauseIcon
{
    if (!_pauseIcon) {
        _pauseIcon = [[UILabel alloc] init];
        _pauseIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _pauseIcon.textColor = [UIColor whiteColor];
        _pauseIcon.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        _pauseIcon.text = @"❚❚";
    }
    return _pauseIcon;
}


#pragma mark - State

- (void)setState:(OriginateSlideshowPlaybackState)state
{
    _state = state;
    switch (state) {
        case OriginateSlideshowPlaybackStatePlaying:
            self.playIcon.hidden = NO;
            self.pauseIcon.hidden = YES;
            break;
        case OriginateSlideshowPlaybackStatePaused:
            self.playIcon.hidden = YES;
            self.pauseIcon.hidden = NO;
            break;
    }
    
    self.iconView.hidden = NO;
    self.iconView.alpha = 1;
    
    [UIView animateWithDuration:0.4
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.iconView.alpha = 0;
                         self.sizeConstraint.constant = 150;
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.sizeConstraint.constant = 80;
                         self.iconView.hidden = YES;
                     }];
}

@end
