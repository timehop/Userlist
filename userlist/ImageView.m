//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "ImageView.h"

#import "ImageViewModel.h"

#import <ReactiveCocoa/RACEXTKeyPathCoding.h>
#import <KVOController/FBKVOController.h>

#pragma mark -

@interface ImageView ()

@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readonly) FBKVOController *kvoController;

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

        _kvoController = [[FBKVOController alloc] initWithObserver:self retainObserved:NO];

        [_kvoController observe:self keyPath:@"viewModel.image" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            UIImage *image = nil;
            if ([change[NSKeyValueChangeNewKey] isKindOfClass:[UIImage class]]) {
                image = change[NSKeyValueChangeNewKey];
            }
            self.image = image;
        }];

        [_kvoController observe:self keyPath:@"viewModel.progress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            if (![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNumber class]]) return;
            self.progressLayer.strokeEnd = [change[NSKeyValueChangeNewKey] floatValue];
        }];

        [_kvoController observe:self keyPath:@"viewModel.loading" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            if (![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNumber class]]) return;
            self.progressLayer.hidden = ![change[NSKeyValueChangeNewKey] boolValue];
        }];
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
