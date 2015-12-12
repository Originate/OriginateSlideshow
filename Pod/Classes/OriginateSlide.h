//
//  OriginateSlide.h
//  Originate
//
//  Created by Allen Wu on 5/25/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

@import Foundation;
@import MediaPlayer;

@protocol OriginateSlide;

NS_ASSUME_NONNULL_BEGIN

@protocol OriginateSlideDelegate <NSObject>

@optional

/// Tells delegate that the slide content has begun downloading
- (void)slideDidBeginLoading:(id<OriginateSlide>)slide;

/// Tells delegate that the slide content is visible
- (void)slideDidBeginPresenting:(id<OriginateSlide>)slide;

/// Tells delegate that the slide content is fully downloaded
- (void)slideDidFinishLoading:(id<OriginateSlide>)slide;

/// Tells delegate that it has completed presenting and is ready to be replaced
- (void)slideDidFinishPresenting:(id<OriginateSlide>)slide;

/// Tells delegate the current download progress of the slide content
- (void)slideLoadingProgress:(CGFloat)percentage;

@end


@protocol OriginateSlide <NSObject>

@property (nonatomic, strong, readonly) NSURL* URL;
@property (nonatomic, weak, nullable) id<OriginateSlideDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)URL;

- (void)loadIntoView:(nullable UIView *)view;
- (void)prepareForDismissal;
- (BOOL)canPreload;
- (Class)requiredContainerViewClass;

@end


@protocol OriginateSlideIntrinsicPlayback <NSObject>

- (NSTimeInterval)duration;
- (void)play;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END

