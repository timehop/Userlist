//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UserCell.h"

#import "ImageView.h"

#import "UserViewModel.h"
#import "ImageViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#pragma mark -

@interface UserCell ()

@property (nonatomic, readonly) ImageView *avatarImageView;

@end

@implementation UserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        _avatarImageView = [[ImageView alloc] init];
        [self.contentView addSubview:_avatarImageView];

        RAC(self.avatarImageView, viewModel) = RACObserve(self, viewModel.imageViewModel);
        RAC(self.textLabel, text) = [RACObserve(self, viewModel.name) ignore:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.avatarImageView.frame = CGRectMake(0, 0, 48, 48);
    self.textLabel.frame = CGRectMake(58, 0, 260, 48);
}

@end
