//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UserViewModel.h"

#import "User.h"

#import "ImageController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#pragma mark -

@interface UserViewModel ()

@property (nonatomic, readonly) RACCommand *loadAvatarImageCommand;
@property (nonatomic, readonly) RACDisposable *loadAvatarImageDisposable;

@end

@implementation UserViewModel

- (instancetype)initWithUser:(User *)user imageController:(ImageController *)imageController {
    self = [super init];
    if (self != nil) {
        _user = user;

        _name = _user.name;

        // Don't bother loading the image if there's already one stored.
        RACSignal *hasAvatarImageSignal =
            [RACObserve(self, avatarImage) map:^id(UIImage *image) {
                return (image != nil) ? @YES : @NO;
            }];

        @weakify(self);

        _loadAvatarImageCommand = [[RACCommand alloc] initWithEnabled:hasAvatarImageSignal signalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [imageController imageAndProgressWithURL:self.user.avatarURL];
        }];

        // Bind avatarImage to the latest output of
        RAC(self, avatarImage) =
            [[[[_loadAvatarImageCommand executionSignals]
                switchToLatest]
                deliverOn:[RACScheduler mainThreadScheduler]]
                startWith:[UIImage imageNamed:@"user_avatar_placeholder"]];

        // Trigger image load when the view model becomes active
        [[self didBecomeActiveSignal]
            subscribeNext:^(UserViewModel *userViewModel) {
                [userViewModel.loadAvatarImageCommand execute:nil];
            }];

    }
    return self;
}

@end
