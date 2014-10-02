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
        [self.layer addSublayer:_progressLayer];

        RAC(self, image) = RACObserve(self, viewModel.image);
        RAC(self.progressLayer, strokeEnd) = RACObserve(self, viewModel.progress);
        RAC(self.progressLayer, hidden) = [RACObserve(self, viewModel.loading) not];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];

    CGFloat const radius = CGRectGetWidth(bounds) * 0.8;
    self.progressLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius].CGPath;
}

#pragma mark UIView

- (void)layoutSubviews {
    self.progressLayer.frame = self.bounds;
}

@end
