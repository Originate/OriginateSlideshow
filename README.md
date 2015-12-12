# OriginateSlideshow

> A customizable slideshow view controller.


![](demo.gif)


## Installation with CocoaPods

Add the following lines to your Podfile and then run `pod install`.

```ruby
source 'https://github.com/Originate/CocoaPods.git'
pod 'OriginateSlideshow'
```


## Usage

Instantiate an `OriginateSlideshowViewController` and assign its `.dataSource` and `.delegate` properties for configuration. This should feel familiar to using a `UITableView`.

To being playing the slideshow, simply call `-resume` on the view controller.

* `OriginateSlideshowDataSource`

  ```objc
  - (NSUInteger)numberOfSlidesInSlideshow:(OriginateSlideshowViewController *)slideshow;
  - (NSTimeInterval)slideshow:(OriginateSlideshowViewController *)slideshow durationForSlideAtIndex:(NSUInteger)index;
  - (NSTimeInterval)bufferDurationAmountForSlideshow:(OriginateSlideshowViewController *)slideshow;
  - (id<OriginateSlide>)slideshow:(OriginateSlideshowViewController *)slideshow slideAtIndex:(NSUInteger)index;
  - (BOOL)slideshowShouldAutomaticallyDismissWhenFinished:(OriginateSlideshowViewController *)slideshow;
  ```


* `OriginateSlideshowDelegate`

  ```objc
  - (void)slideshowIsReady:(OriginateSlideshowViewController *)slideshow;
  - (void)slideshowIsFinished:(OriginateSlideshowViewController *)slideshow;
  - (void)slideshowIsDismissed:(OriginateSlideshowViewController *)slideshow;
  ```

## License

OriginateSlideshow is available under the MIT license. See the [LICENSE](/LICENSE) file for more info.
