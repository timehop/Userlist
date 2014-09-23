//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class SDWebImageManager;
@class RACSignal;

@interface ImageController : NSObject

/// Instance initializer.
- (instancetype)initWithImageManager:(SDWebImageManager *)imageManager;

/// Shared instance will use the shared SDWebImageManager.
+ (instancetype)sharedController;

# pragma mark Image fetching

/// Sends the UIImage at the specified URL and completes.
/// Sends an error if the image fails to load.
/// Handles web URLs and ALAsset URLs.
- (RACSignal *)imageWithURL:(NSURL *)imageURL;

/// Sends the placeholder image, then the UIImage at the specified URL and completes.
- (RACSignal *)imageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;

/// Same as `imageWithURL` except signal also sends the progress of the download in a tuple.
/// Sends RACTuple(UIImage *downloadedImage, NSNumber *progress) at unspecified intervals,
/// where progress is a double == 0..1, and downloadedImage in nil for 0..0.99 and
/// the complete image for progress == 1.
- (RACSignal *)imageAndProgressWithURL:(NSURL *)imageURL;

# pragma mark Cache maintenance

/// Clears out only expired images from the disk cache then completes.
- (RACSignal *)cleanExpiredCaches;

/// Completely deletes SDWebImage disk cache and memory cache then completes.
- (RACSignal *)purgeLocalCaches;

# pragma mark Convenience

/// Returns a signal that immediately returns an image from the bundle.
/// Returns error if the image is not found.
+ (RACSignal *)imageNamed:(NSString *)name;

@end
