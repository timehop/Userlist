//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "SDWebImageManager.h"

@class RACSignal;

#pragma mark -

@interface SDWebImageManager (RACSignalSupport)

/// Sends one or more images then completes.
/// Sends an error if there was an issue downloading the image.
- (RACSignal *)rac_imageWithURL:(NSURL *)url options:(SDWebImageOptions)options;

/// Sends one or more RACTuple(UIImage *image, NSNumber *progress) where:
///      image - an image, or nil if the download is still in progress.
///      progess - an NSNumber 0..1 that corresponds to the download progress.
/// Sends an error if there was an issue downloading the image.
- (RACSignal *)rac_imageAndProgressWithURL:(NSURL *)url options:(SDWebImageOptions)options;

@end
