//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "User.h"


#pragma mark -

@implementation User

- (instancetype)initWithName:(NSString *)name avatarURL:(NSURL *)avatarURL {
    self = [super init];
    if (self != nil) {
        _name = name;
        _avatarURL = avatarURL;
    }
    return self;
}

@end
