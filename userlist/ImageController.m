//
//  TimehopThree
//  Copyright (c) 2014 Timehop. All rights reserved.
//

#import "ImageController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <SDWebImage/SDWebImageManager.h>
#import "SDWebImageManager+RACSignalSupport.h"

@interface ImageController ()

@property (nonatomic, readonly) SDWebImageManager *imageManager;

@end

@implementation ImageController

- (instancetype)initWithImageManager:(SDWebImageManager *)imageManager {
    NSParameterAssert(imageManager != nil);
    self = [super init];
    if (self != nil) {
        _imageManager = imageManager;
    }
    return self;
}

+ (instancetype)sharedController {
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    static ImageController *imageController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageController = [[ImageController alloc] initWithImageManager:imageManager];
    });
    return imageController;
}

# pragma mark Image Fetching

- (RACSignal *)imageWithURL:(NSURL *)imageURL {
    return [[[self imageAndProgressWithURL:imageURL]
                map:^UIImage *(RACTuple *t) {
                    UIImage *image = t.first;
                    return image;
                }]
                ignore:nil];
}

- (RACSignal *)imageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage {
    return [[self imageWithURL:imageURL] startWith:placeholderImage];
}

- (RACSignal *)imageAndProgressWithURL:(NSURL *)imageURL {
    if (imageURL == nil) {
        return [RACSignal error:[NSError errorWithDomain:@"com.twocentstudios.userlist" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"No image URL specified."} ]];
    }

    return [self.imageManager rac_imageAndProgressWithURL:imageURL options:SDWebImageRetryFailed];
}

# pragma mark Cache maintenance

- (RACSignal *)cleanExpiredCaches {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.imageManager.imageCache cleanDiskWithCompletionBlock:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)purgeLocalCaches {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.imageManager.imageCache clearMemory];
        [self.imageManager.imageCache clearDiskOnCompletion:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

# pragma mark Convenience

+ (RACSignal *)imageNamed:(NSString *)name {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        UIImage *image = [UIImage imageNamed:name];
        if (image == nil) {
            [subscriber sendError:[NSError errorWithDomain:@"com.twocentstudios.userlist" code:1 userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Image %@ not found in bundle.", name] } ]];
        } else {
            [subscriber sendNext:image];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

@end
