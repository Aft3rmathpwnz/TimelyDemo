//
//  TDSeparatorTableView.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 16/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import "TDSeparatorTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TDSeparatorTableView()

@property (strong, nonatomic) NSMutableArray *separatorLayers;

/**
 Initializes array for separators' references and sets separator style to None to hide the default ones.
 */
- (void)setupInitially;
/**
 Fills empty table space with dotted separators. If its content size is higher than its frame, then onle 1 separator got added.
 */
- (void)fillTableViewWithSeparators;

@end

NS_ASSUME_NONNULL_END

@implementation TDSeparatorTableView

#pragma mark - Properties

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    for (CALayer *separatorLayer in _separatorLayers) {
        [separatorLayer removeFromSuperlayer];
    }
    [_separatorLayers removeAllObjects];
    
    [self fillTableViewWithSeparators];
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupInitially];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupInitially];
    }
    return self;
}

#pragma mark - Private

- (void)setupInitially {
    self.separatorLayers = [NSMutableArray array];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)fillTableViewWithSeparators {
    int sep_count = 0;
    CGFloat y = self.contentSize.height;
    do {
        y += 25.0f;
        CALayer *separatorLayer = [CALayer layer];
        separatorLayer.frame = CGRectMake(20, y, CGRectGetWidth(self.frame) - 40, 1.0f);
        separatorLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"separator"]].CGColor;
        [self.layer insertSublayer:separatorLayer atIndex:0];
        [_separatorLayers addObject:separatorLayer];
        sep_count++;
    } while (y <= MAX(CGRectGetHeight(self.frame), self.contentSize.height));
}

@end
