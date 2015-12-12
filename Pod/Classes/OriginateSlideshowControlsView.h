//
//  OriginateSlideshowControlsView.h
//  Originate
//
//  Created by Allen Wu on 5/28/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

@import UIKit;

@interface OriginateSlideshowControlsView : UIView

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) UIButton* restartButton;
@property (nonatomic, strong) UIProgressView* progressView;

- (void)fadeAwayWithDelay:(NSTimeInterval)delay;
- (void)show;

@end
