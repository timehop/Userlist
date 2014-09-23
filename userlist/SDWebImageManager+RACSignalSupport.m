//
//  TimehopThree
//  Copyright (c) 2014 Timehop. All rights reserved.
//

#import "SDWebImageManager+RACSignalSupport.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#pragma mark -

@implementation SDWebImageManager (RACSignalSupport)

- (RACSignal *)rac_imageWithURL:(NSURL *)url options:(SDWebImageOptions)options {
    return [[self rac_imageAndProgressWithURL:url options:options]
                filter:^BOOL(RACTuple *t) {
                    UIImage *image = t.first;
                    return (image != nil);
                }];
}

- (RACSignal *)rac_imageAndProgressWithURL:(NSURL *)url options:(SDWebImageOptions)options {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        id<SDWebImageOperation> operation =
        [self downloadImageWithURL:url
                           options:options
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                              if (expectedSize > 0 && receivedSize < expectedSize) {
                                  [subscriber sendNext:RACTuplePack(nil, @(receivedSize/(CGFloat)expectedSize))];
                              }
                          }
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                             if (error != nil) {
                                 [subscriber sendError:error];
                             }

                             [subscriber sendNext:RACTuplePack(image, @1)];

                             if (finished) {
                                 [subscriber sendCompleted];
                             }
                         }];

        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

@end
