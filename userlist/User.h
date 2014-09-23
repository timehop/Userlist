//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#pragma mark -

@interface User : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSURL *avatarURL;

- (instancetype)initWithName:(NSString *)name avatarURL:(NSURL *)avatarURL;

@end
