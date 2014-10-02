//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class User;
@class ImageViewModel;
@class ImageController;

#pragma mark -

@interface UserViewModel : RVMViewModel

@property (nonatomic, readonly) User *user;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) ImageViewModel *imageViewModel;

- (instancetype)initWithUser:(User *)user imageController:(ImageController *)imageController;

@end
