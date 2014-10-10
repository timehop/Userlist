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
@property (nonatomic, readonly) void (^fetchImageBlock)(void);

@property (nonatomic) UIImage *image;
@property (nonatomic) CGFloat progress;
@property (nonatomic) NSError *error;

@property (nonatomic) BOOL hasError;
@property (nonatomic, getter=isLoading) BOOL loading;

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
        _loading = NO;

        @weakify(self);

        _fetchImageBlock = ^{
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
            
            [self hasError] ? self.fetchImageBlock() : self.openImageURLBlock(self.imageURL);
        };

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

- (void)setActive:(BOOL)active {
    if (_active == active) return;

    _active = active;

    if (active) {
        if (self.image == nil) {
            self.fetchImageBlock();
        }
    } else {
        self.setImageBlock = nil;
        self.setProgressBlock = nil;
        self.setErrorBlock = nil;
        self.setHasErrorBlock = nil;
        self.setLoadingBlock = nil;
    }
}

- (void)setImage:(UIImage *)image {
    if (_image == image) return;

    _image = image;

    if (self.setImageBlock != nil) {
        self.setImageBlock(_image);
    }
}

- (void)setProgress:(CGFloat)progress {
    if (_progress == progress) return;

    _progress = progress;

    self.loading = (_progress == 1.0) ? NO : YES;

    if (self.setProgressBlock != nil) {
        self.setProgressBlock(_progress);
    }
}

- (void)setError:(NSError *)error {
    if (_error == error) return;

    _error = error;

    self.hasError = (_error != nil);

    if (self.setErrorBlock != nil) {
        self.setErrorBlock(_error);
    }
}

- (void)setHasError:(BOOL)hasError {
    if (_hasError == hasError) return;

    _hasError = hasError;

    if (self.setHasErrorBlock != nil) {
        self.setHasErrorBlock(_hasError);
    }
}

- (void)setLoading:(BOOL)loading {
    if (_loading == loading) return;

    _loading = loading;

    if (self.setLoadingBlock != nil) {
        self.setLoadingBlock(_loading);
    }
}

@end
