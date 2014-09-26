//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UserController.h"

#import "User.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <LoremIpsum/LoremIpsum.h>

#pragma mark -

@implementation UserController

- (RACSignal *)fetchRandomUsers:(NSUInteger)numberOfUsers {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *usersArray = [NSMutableArray array];
        for (int i = 0; i < numberOfUsers; i++) {
            NSString *name = [LoremIpsum name];
            NSURL *avatarURL = [[LoremIpsum URLForPlaceholderImageFromService:LIPlaceholderImageServiceHhhhold withSize:CGSizeMake(96, 96)] URLByAppendingPathComponent:[NSString stringWithFormat:@"jpg?test=%i", i]];
            User *user = [[User alloc] initWithName:name avatarURL:avatarURL];
            [usersArray addObject:user];
        }
        [subscriber sendNext:[usersArray copy]];
        [subscriber sendCompleted];
        return nil;
    }];
}

@end
