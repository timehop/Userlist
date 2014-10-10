//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "ImageView.h"

#import "ImageViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#pragma mark -

@interface ImageView ()

@property (nonatomic, readonly) CAShapeLayer *progressLayer;

@end

@implementation ImageView

- (instancetype)initWithImage:(UIImage *)image {
    NSAssert(NO, @"Use `initWithViewModel:`");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor blueColor].CGColor;
        _progressLayer.lineWidth = 3;
        _progressLayer.actions = @{ @"strokeEnd": [NSNull null] };
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)setViewModel:(ImageViewModel *)viewModel {
    if (_viewModel == viewModel) return;

    _viewModel = viewModel;

    @weakify(self);

    self.image = _viewModel.image;
    self.progressLayer.strokeEnd = _viewModel.progress;
    self.progressLayer.hidden = !_viewModel.loading;

    _viewModel.setImageBlock = ^(UIImage *image) {
        @strongify(self);
        self.image = image;
    };

    _viewModel.setProgressBlock = ^(CGFloat progress) {
        @strongify(self);
        self.progressLayer.strokeEnd = progress;
    };

    _viewModel.setLoadingBlock = ^(BOOL loading) {
        @strongify(self);
        self.progressLayer.hidden = !loading;
    };
}

#pragma mark UIView

- (void)layoutSubviews {
    CGFloat const scale = 0.7;
    CGFloat const side = CGRectGetWidth(self.bounds) * scale;
    CGFloat const radius = side * 0.5;
    self.progressLayer.frame = CGRectMake(CGRectGetMidX(self.bounds)-radius, CGRectGetMidY(self.bounds)-radius, side, side);
    self.progressLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, side, side) cornerRadius:radius].CGPath;
}

@end
