//
//  ExampleViewController.m
//  OriginateSlideshow
//
//  Created by Allen Wu on 12/10/2015.
//  Copyright (c) 2015 Allen Wu. All rights reserved.
//

#import "ExampleViewController.h"
#import "ExampleSlidePhoto.h"

@interface ExampleViewController () <OriginateSlideshowDataSource,
                                     OriginateSlideshowDelegate>

@property (nonatomic, strong) OriginateSlideshowViewController *slideshowViewController;
@property (nonatomic, copy) NSArray *slideURLs;

@end

@implementation ExampleViewController

- (IBAction)launchSlideshowButtonPressed:(id)sender
{
    [self presentViewController:self.slideshowViewController
                       animated:YES
                     completion:^{
                         [self.slideshowViewController resume];
                     }];
}


#pragma mark - Properties

- (OriginateSlideshowViewController *)slideshowViewController
{
    if (!_slideshowViewController) {
        _slideshowViewController = [[OriginateSlideshowViewController alloc] init];
        _slideshowViewController.dataSource = self;
        _slideshowViewController.delegate = self;
    }
    
    return _slideshowViewController;
}

- (NSArray *)slideURLs
{
    if (!_slideURLs) {
        _slideURLs = @[@"http://www.originate.com/images/dynamic/W1siZnUiLCJodHRwczovL29yaWdpbmF0ZS12My1wcm9kLnMzLmFtYXpvbmF3cy5jb20vc2l0ZXMvNTM4NTQ3ODVkYzYwZDk0Yjk2MDAwMDAyL2NvbnRlbnRfZW50cnk1Mzg1NDg2OWRjNjBkOTRiOTYwMDAwMTIvNTM4NzkwOWY3MDc5ZGIwNjdiMDAwMDY3L2ZpbGVzL05ld1lvcmsyLmpwZz8xNDIzMDk1MjY0Il0sWyJwIiwidGh1bWIiLCIxMDAweDEwMDBcdTAwM0UiXV0/NewYork2.jpg?sha=c74d57736a80ae04",
                       @"http://www.originate.com/images/dynamic/W1siZnUiLCJodHRwczovL29yaWdpbmF0ZS12My1wcm9kLnMzLmFtYXpvbmF3cy5jb20vc2l0ZXMvNTM4NTQ3ODVkYzYwZDk0Yjk2MDAwMDAyL2NvbnRlbnRfZW50cnk1Mzg1NDg2OWRjNjBkOTRiOTYwMDAwMTIvNTM4NzkwYTk3MDc5ZGIwNjdiMDAwMDY5L2ZpbGVzL0xvc0FuZ2VsZXMyLmpwZz8xNDIzMDk1OTAzIl0sWyJwIiwidGh1bWIiLCIxMDAweDEwMDBcdTAwM0UiXV0/LosAngeles2.jpg?sha=5bdb3c464406070e",
                       @"http://www.originate.com/images/dynamic/W1siZnUiLCJodHRwczovL29yaWdpbmF0ZS12My1wcm9kLnMzLmFtYXpvbmF3cy5jb20vc2l0ZXMvNTM4NTQ3ODVkYzYwZDk0Yjk2MDAwMDAyL2NvbnRlbnRfZW50cnk1Mzg1NDg2OWRjNjBkOTRiOTYwMDAwMTIvNTM4NzkwYjI3MDc5ZGIwNjdiMDAwMDZiL2ZpbGVzL1NhbkZyYW42LmpwZz8xNDIzMDk1Nzk1Il0sWyJwIiwidGh1bWIiLCIxMDAweDEwMDBcdTAwM0UiXV0/SanFran6.jpg?sha=06aa718a5fd04dc5",
                       @"http://www.originate.com/images/dynamic/W1siZnUiLCJodHRwczovL29yaWdpbmF0ZS12My1wcm9kLnMzLmFtYXpvbmF3cy5jb20vc2l0ZXMvNTM4NTQ3ODVkYzYwZDk0Yjk2MDAwMDAyL2NvbnRlbnRfZW50cnk1Mzg1NDg2OWRjNjBkOTRiOTYwMDAwMTIvNTM4NzkwZGI3MDc5ZGIwNjdiMDAwMDZmL2ZpbGVzL0xhc1ZlZ2FzMy5qcGc%2FMTQyMzA5NTMxNiJdLFsicCIsInRodW1iIiwiMTAwMHgxMDAwXHUwMDNFIl1d/LasVegas3.jpg?sha=474e38b623dd9f42",
                       @"http://www.originate.com/images/dynamic/W1siZnUiLCJodHRwczovL29yaWdpbmF0ZS12My1wcm9kLnMzLmFtYXpvbmF3cy5jb20vc2l0ZXMvNTM4NTQ3ODVkYzYwZDk0Yjk2MDAwMDAyL2NvbnRlbnRfZW50cnk1Mzg1NDg2OWRjNjBkOTRiOTYwMDAwMTIvNTM4ZTMzY2MyMzdmN2YzYzQ0MDAwMDAxL2ZpbGVzL09yYW5nZUNvdW50eTIuanBnPzE0Mjc3NDE1MDQiXSxbInAiLCJ0aHVtYiIsIjEwMDB4MTAwMFx1MDAzRSJdXQ/OrangeCounty2.jpg?sha=c1c8f560295f8cf6",
                       @"http://www.originate.com/images/dynamic/W1siZnUiLCJodHRwczovL29yaWdpbmF0ZS12My1wcm9kLnMzLmFtYXpvbmF3cy5jb20vc2l0ZXMvNTM4NTQ3ODVkYzYwZDk0Yjk2MDAwMDAyL2NvbnRlbnRfZW50cnk1Mzg1NDg2OWRjNjBkOTRiOTYwMDAwMTIvNTM4ZTJjYjY5NzFhYmFhNzlkMDAwMDAxL2ZpbGVzL1NpbGljb25fVmFsbGV5Mi5qcGc%2FMTQzNTI3MzM4NCJdLFsicCIsInRodW1iIiwiMTAwMHgxMDAwXHUwMDNFIl1d/Silicon_Valley2.jpg?sha=0483dae5d2f1f1ed"];
    }
    
    return _slideURLs;
}


#pragma mark - <OriginateSlideshowDataSource>

- (NSUInteger)numberOfSlidesInSlideshow:(OriginateSlideshowViewController *)slideshow
{
    return self.slideURLs.count;
}

- (NSTimeInterval)slideshow:(OriginateSlideshowViewController *)slideshow durationForSlideAtIndex:(NSUInteger)index
{
    return 3.0;
}

- (NSTimeInterval)bufferDurationAmountForSlideshow:(OriginateSlideshowViewController *)slideshow
{
    return 6.0;
}

- (id<OriginateSlide>)slideshow:(OriginateSlideshowViewController *)slideshow slideAtIndex:(NSUInteger)index
{
    return [[ExampleSlidePhoto alloc] initWithURL:[NSURL URLWithString:self.slideURLs[index]]];
}

- (BOOL)slideshowShouldAutomaticallyDismissWhenFinished:(OriginateSlideshowViewController *)slideshow
{
    return YES;
}


#pragma mark - <OriginateSlideshowDelegate>

- (void)slideshowIsReady:(OriginateSlideshowViewController *)slideshow
{
    NSLog(@"Slideshow has been buffered and is ready");
}

- (void)slideshowIsFinished:(OriginateSlideshowViewController *)slideshow
{
    NSLog(@"Slideshow is finished!");
}

- (void)slideshowIsDismissed:(OriginateSlideshowViewController *)slideshow
{
    NSLog(@"Slideshow is dismissed!");
    
    [self.slideshowViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
