//
//  ExampleSlidePhoto.m
//  OriginateSlideshow
//
//  Created by Allen Wu on 12/12/15.
//  Copyright © 2015 Allen Wu. All rights reserved.
//

#import "ExampleSlidePhoto.h"

@interface ExampleSlidePhoto ()

@property (nonatomic, strong) NSURLSessionTask *downloadTask;

@end

@implementation ExampleSlidePhoto

@synthesize delegate;
@synthesize URL = _URL;

#pragma mark - <OriginateSlide>

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    
    if (self) {
        _URL = URL;
    }
    
    return self;
}

- (void)loadIntoView:(UIImageView *)view
{
    NSAssert(view == nil || [view isKindOfClass:[self requiredContainerViewClass]], @"Slide requires a container view of type %@", [self requiredContainerViewClass]);
    
    if ([self.delegate respondsToSelector:@selector(slideDidBeginLoading:)]) {
        [self.delegate slideDidBeginLoading:self];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    self.downloadTask = [session dataTaskWithURL:self.URL
                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                         {
                             NSHTTPURLResponse *HTTPResponse = (id)response;
                             if (data && HTTPResponse.statusCode >= 200 && HTTPResponse.statusCode <= 299) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     UIImage *image = [UIImage imageWithData:data];
                                     if (image) {
                                         if ([self.delegate respondsToSelector:@selector(slideDidBeginPresenting:)]) {
                                             [self.delegate slideDidBeginPresenting:self];
                                         }
                                         
                                         if ([self.delegate respondsToSelector:@selector(slideDidFinishLoading:)]) {
                                             [self.delegate slideDidFinishLoading:self];
                                         }
                                         
                                         view.image = image;
                                         
                                         if ([self.delegate respondsToSelector:@selector(slideDidFinishPresenting:)]) {
                                             [self.delegate slideDidFinishPresenting:self];
                                         }
                                     }
                                 });
                             }
                         }];
    
    [self.downloadTask resume];
}

- (void)prepareForDismissal
{
    [self.downloadTask cancel];
}

- (BOOL)canPreload
{
    return YES;
}

- (Class)requiredContainerViewClass
{
    return [UIImageView class];
}

@end
