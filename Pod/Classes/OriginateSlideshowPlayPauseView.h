//
//  OriginateSlideshowPlayPauseView.h
//  Originate
//
//  Created by Allen Wu on 5/28/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, OriginateSlideshowPlaybackState) {
  OriginateSlideshowPlaybackStatePlaying,
  OriginateSlideshowPlaybackStatePaused
};

@interface OriginateSlideshowPlayPauseView : UIView

@property (nonatomic, assign) OriginateSlideshowPlaybackState state;

@end
