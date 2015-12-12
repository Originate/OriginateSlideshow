//
//  OriginateSlideshowViewController.h
//  Originate
//
//  Created by Allen Wu on 5/21/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

@import UIKit;
@import MediaPlayer;

#import "OriginateSlide.h"


@class OriginateSlideshowViewController;

@protocol OriginateSlideshowDataSource <NSObject>

@required

- (NSUInteger)numberOfSlidesInSlideshow:(OriginateSlideshowViewController *)slideshow;
- (NSTimeInterval)slideshow:(OriginateSlideshowViewController *)slideshow durationForSlideAtIndex:(NSUInteger)index;
- (NSTimeInterval)bufferDurationAmountForSlideshow:(OriginateSlideshowViewController *)slideshow;
- (id<OriginateSlide>)slideshow:(OriginateSlideshowViewController *)slideshow slideAtIndex:(NSUInteger)index;
- (BOOL)slideshowShouldAutomaticallyDismissWhenFinished:(OriginateSlideshowViewController *)slideshow;

@optional

// TODO
- (void)slideshow:(OriginateSlideshowViewController *)slideshow transitionInForSlideAtIndex:(NSUInteger)index;
- (void)slideshow:(OriginateSlideshowViewController *)slideshow transitionOutForSlideAtIndex:(NSUInteger)index;

@end


@protocol OriginateSlideshowDelegate <NSObject>

@required

/// Implement this delegate method to be notified when the slideshow is ready for playback.
- (void)slideshowIsReady:(OriginateSlideshowViewController *)slideshow;
- (void)slideshowIsFinished:(OriginateSlideshowViewController *)slideshow;
- (void)slideshowIsDismissed:(OriginateSlideshowViewController *)slideshow;

@end


@interface OriginateSlideshowViewController : UIViewController

@property (nonatomic, weak) id<OriginateSlideshowDataSource> dataSource;
@property (nonatomic, weak) id<OriginateSlideshowDelegate> delegate;

- (void)resume;

@end
