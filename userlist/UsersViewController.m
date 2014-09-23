//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UsersViewController.h"

#import "UsersViewModel.h"
#import "UserViewModel.h"

#import "UserCell.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#pragma mark -

@interface UsersViewController ()

@property (nonatomic, readonly) UsersViewModel *viewModel;

@end


@implementation UsersViewController

- (instancetype)initWithViewModel:(UsersViewModel *)viewModel {
    self = [super init];
    if (self != nil) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UserCell class] forCellReuseIdentifier:NSStringFromClass([UserCell class])];

    @weakify(self);

    self.title = NSLocalizedString(@"Random Users", nil);

    [[RACObserve(self.viewModel, userViewModels)
        ignore:nil]
        subscribeNext:^(id _) {
            @strongify(self);
            [self.tableView reloadData];
        }];

    [self.viewModel.userViewModelsCommand execute:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.userViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserViewModel *viewModel = self.viewModel.userViewModels[indexPath.row];

    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserCell class]) forIndexPath:indexPath];
    cell.viewModel = viewModel;
    return cell;
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *userCell = (UserCell *)cell;
    userCell.viewModel.active = YES;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *userCell = (UserCell *)cell;
    userCell.viewModel.active = NO;
}

@end
