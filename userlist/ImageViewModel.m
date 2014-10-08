//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "ImageViewModel.h"

#import "ImageController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#pragma mark -

@interface ImageViewModel ()

@property (nonatomic, readonly) ImageController *imageController;
@property (nonatomic, readonly) void (^openImageURLBlock)(NSURL *);

@property (nonatomic) UIImage *image;
@property (nonatomic) CGFloat progress;
@property (nonatomic) NSError *error;

@property (nonatomic) RACDisposable *imageDisposable;

@end

@implementation ImageViewModel

- (instancetype)initWithImageURL:(NSURL *)imageURL openImageURLBlock:(void (^)(NSURL *))openImageURLBlock imageController:(ImageController *)imageController {
    self = [super init];
    if (self != nil) {
        _imageURL = imageURL;
        _openImageURLBlock = openImageURLBlock ?: ^(id _){};
        _imageController = imageController;

        _progress = 1.0;

        RAC(self, hasError) =
            [RACObserve(self, error)
                map:^NSNumber *(NSError *error) {
                    return @(error != nil);
                }];

        RAC(self, loading) =
            [RACObserve(self, progress)
                map:^NSNumber *(NSNumber *progress) {
                    return ([progress floatValue] == 1.0) ? @NO : @YES;
                }];

        @weakify(self);

        void (^fetchImageBlock)(void) = ^{
            @strongify(self);
            if (self.imageDisposable != nil) return;

            self.imageDisposable =
                [[[[self.imageController imageAndProgressWithURL:self.imageURL]
                    deliverOn:[RACScheduler mainThreadScheduler]]
                    initially:^{
                        @strongify(self);
                        self.progress = 0;
                        self.image = nil;
                        self.error = nil;
                    }]
                    subscribeNext:^(RACTuple *t) {
                        @strongify(self);
                        RACTupleUnpack(UIImage *image, NSNumber *progress) = t;
                        self.progress = [progress floatValue];
                        if (self.progress == 1.0) {
                            self.image = image;
                        }
                    } error:^(NSError *error) {
                        @strongify(self);
                        self.image = nil;
                        self.progress = 1;
                        self.error = error;
                    } completed:^{
                        @strongify(self);
                        self.error = nil;
                        self.progress = 1;
                    }];
        };

        _selectImageBlock = ^{
            @strongify(self);
            if (self.image == nil) return;
            
            [self hasError] ? fetchImageBlock() : self.openImageURLBlock(self.imageURL);
        };

        [[self didBecomeActiveSignal]
            subscribeNext:^(ImageViewModel *viewModel) {
                if (viewModel.image == nil) {
                    fetchImageBlock();
                }
            }];

        // Disposing the image fetching signal has some overhead. It's also slightly different functionally than the previous
        // versions, so leaving it out for this run.
        //[[self didBecomeInactiveSignal]
        //    subscribeNext:^(ImageViewModel *viewModel) {
        //        [viewModel.imageDisposable dispose];
        //        viewModel.imageDisposable = nil;
        //    }];

        // It's probably too heavy to create a new signal for every one of these view models
        // [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil]
        //    subscribeNext:^(id _) {
        //        @strongify(self);
        //        self.image = nil;
        //    }];

    }
    return self;
}

@end
