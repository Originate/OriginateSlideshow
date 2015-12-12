//
//  OriginateSlideshowBuffer.h
//  Originate
//
//  Created by Allen Wu on 6/2/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

@import Foundation;

#import "OriginateSlide.h"
#import "OriginateSlideshowViewController.h"

@class OriginateSlideshowBuffer;

@protocol OriginateSlideshowBufferDelegate <NSObject>

- (void)slideshowBufferingDidBegin:(OriginateSlideshowBuffer *)buffer;
- (void)slideshowBufferingDidFinish:(OriginateSlideshowBuffer *)buffer;

@end


/// A simple object that asynchronously loads slideshow content offscreen
@interface OriginateSlideshowBuffer : NSObject

@property (nonatomic, weak) id<OriginateSlideshowBufferDelegate> delegate;

- (instancetype)initWithSlideshow:(OriginateSlideshowViewController *)slideshow
                       dataSource:(id<OriginateSlideshowDataSource>)dataSource;

- (void)bufferStartingAtIndex:(NSUInteger)index
                     duration:(NSTimeInterval)duration;

@end