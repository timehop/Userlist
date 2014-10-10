//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class ImageController;

#pragma mark -

@interface ImageViewModel : NSObject

/// The view model's "model".
@property (nonatomic, readonly) NSURL *imageURL;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) CGFloat progress; // 0..0.99 when loading, 1.0 otherwise
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL hasError;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, getter=isActive) BOOL active;

/// Executing this block:
/// * Refetches the image if there was an error.
/// * Executes the openImageURLBlock passed in at initialization if the image is loaded.
/// * Does nothing if the image is unset.
@property (nonatomic, readonly) void (^selectImageBlock)(void);

@property (nonatomic, copy) void (^setImageBlock)(UIImage *);
@property (nonatomic, copy) void (^setProgressBlock)(CGFloat);
@property (nonatomic, copy) void (^setErrorBlock)(NSError *);
@property (nonatomic, copy) void (^setHasErrorBlock)(BOOL);
@property (nonatomic, copy) void (^setLoadingBlock)(BOOL);

- (instancetype)initWithImageURL:(NSURL *)imageURL openImageURLBlock:(void (^)(NSURL *))openImageURLBlock imageController:(ImageController *)imageController;

@end
