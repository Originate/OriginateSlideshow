//
//  OriginateSlideshowView.h
//  Originate
//
//  Created by Allen Wu on 5/27/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

@import UIKit;
#import "OriginateSlideshowPlayPauseView.h"
#import "OriginateSlideshowControlsView.h"

@interface OriginateSlideshowView : UIView

@property (nonatomic, strong) UIButton* dismissSlideshowButton;
@property (nonatomic, strong) UIImageView* photoContainerView;
@property (nonatomic, strong) UIView* videoContainerView;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@property (nonatomic, strong) OriginateSlideshowPlayPauseView* playPauseView;
@property (nonatomic, strong) OriginateSlideshowControlsView* controlsView;

@end
