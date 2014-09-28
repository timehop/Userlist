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

@property (nonatomic) UIImage *avatarImage;

@end

@implementation UserViewModel

- (instancetype)initWithUser:(User *)user imageController:(ImageController *)imageController {
    self = [super init];
    if (self != nil) {
        _user = user;

        _name = _user.name;

        _avatarImage = [UIImage imageNamed:@"user_avatar_placeholder"];

        @weakify(self);

        // Trigger image load when the view model becomes active.
        // Currently ignoring load errors.
        [[[[[[self didBecomeActiveSignal]
            take:1]
            flattenMap:^RACSignal *(UserViewModel *userViewModel) {
                return [imageController imageWithURL:userViewModel.user.avatarURL];
            }]
            ignore:nil]
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribeNext:^(UIImage *image) {
                @strongify(self);
                self.avatarImage = image;
            }];

    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ | %@ | %@", self.user.name, self.user.avatarURL, self.avatarImage];
}

@end
