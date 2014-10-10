//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class User;
@class ImageViewModel;
@class ImageController;

#pragma mark -

@interface UserViewModel : NSObject

@property (nonatomic, readonly) User *user;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) ImageViewModel *imageViewModel;

@property (nonatomic, getter=isActive) BOOL active;

- (instancetype)initWithUser:(User *)user imageController:(ImageController *)imageController;

@end
