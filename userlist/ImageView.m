//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "ImageView.h"

#import "ImageViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

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

        RAC(self, image) = RACObserve(self, viewModel.image);
        RAC(self.progressLayer, strokeEnd) = [RACObserve(self, viewModel.progress) ignore:nil];
        RAC(self.progressLayer, hidden) = [[RACObserve(self, viewModel.loading) ignore:nil] not];
    }
    return self;
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
