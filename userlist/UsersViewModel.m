//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UsersViewModel.h"

#import "UserViewModel.h"

#import "UserController.h"

#import "User.h"

#import "ImageController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#pragma mark -

@implementation UsersViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        UserController *userController = [[UserController alloc] init];
        ImageController *imageController = [ImageController sharedController];

        _userViewModelsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            return [[[userController fetchUsers:100]
                        subscribeOn:[RACScheduler scheduler]]
                        map:^NSArray *(NSArray *users) {
                            return [[[users rac_sequence]
                                        map:^UserViewModel *(User *user) {
                                            return [[UserViewModel alloc] initWithUser:user imageController:imageController];
                                        }]
                                        array];
                        }];
        }];

        RAC(self, userViewModels) =
            [[[_userViewModelsCommand executionSignals]
                switchToLatest]
                deliverOn:[RACScheduler mainThreadScheduler]];

        RAC(self, loading) =
            [_userViewModelsCommand executing];
    }
    return self;
}

@end
