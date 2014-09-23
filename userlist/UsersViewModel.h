//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class RACCommand;

#pragma mark -

@interface UsersViewModel : RVMViewModel

/// Array of UserViewModel objects filled by userViewModelsCommand.
@property (nonatomic, readonly) NSArray *userViewModels;

/// Input: nil
@property (nonatomic, readonly) RACCommand *userViewModelsCommand;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;

@end
