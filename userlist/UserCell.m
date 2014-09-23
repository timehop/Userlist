//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UserCell.h"

#import "UserViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#pragma mark -

@implementation UserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        RAC(self.imageView, image) = RACObserve(self, viewModel.avatarImage);
        RAC(self.textLabel, text) = [RACObserve(self, viewModel.name) ignore:nil];
    }
    return self;
}

@end
