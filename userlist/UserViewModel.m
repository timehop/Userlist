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

@property (nonatomic, readonly) UIImage *networkAvatarImage;

@end

@implementation UserViewModel

- (instancetype)initWithUser:(User *)user imageController:(ImageController *)imageController {
    self = [super init];
    if (self != nil) {
        _user = user;

        _name = _user.name;

        // Don't bother loading the image if there's already one stored.
        RACSignal *hasAvatarImageSignal =
            [RACObserve(self, networkAvatarImage)
                map:^id(UIImage *image) {
                    return (image != nil) ? @YES : @NO;
                }];

        @weakify(self);

        _loadAvatarImageCommand = [[RACCommand alloc] initWithEnabled:[hasAvatarImageSignal not] signalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [imageController imageWithURL:self.user.avatarURL];
        }];

        // Bind networkAvatarImage to the latest output of command
        RAC(self, networkAvatarImage) =
            [[[_loadAvatarImageCommand executionSignals]
                switchToLatest]
                distinctUntilChanged];

        // avatarImage starts as a placeholder image, then is replaced by network image as it becomes available
        RAC(self, avatarImage) =
            [[[RACObserve(self, networkAvatarImage)
                ignore:nil]
                startWith:[UIImage imageNamed:@"user_avatar_placeholder"]]
                deliverOn:[RACScheduler mainThreadScheduler]];

        // Trigger image load when the view model becomes active
        [[self didBecomeActiveSignal]
            subscribeNext:^(UserViewModel *userViewModel) {
                [userViewModel.loadAvatarImageCommand execute:nil];
            }];

    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ | %@ | %@", self.user.name, self.user.avatarURL, self.avatarImage];
}

@end
