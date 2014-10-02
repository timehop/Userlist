//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UserViewModel.h"

#import "ImageViewModel.h"

#import "User.h"

#import "ImageController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#pragma mark -

@implementation UserViewModel

- (instancetype)initWithUser:(User *)user imageController:(ImageController *)imageController {
    self = [super init];
    if (self != nil) {
        _user = user;

        _name = _user.name;

        _imageViewModel = [[ImageViewModel alloc] initWithImageURL:_user.avatarURL openImageURLBlock:nil imageController:imageController];

        // Is this heavy?
        RAC(self.imageViewModel, active) = RACObserve(self, active);

    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ | %@ | %@", self.user.name, self.user.avatarURL, self.imageViewModel.image];
}

@end
