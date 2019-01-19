//
//  TimeEntryView.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Views
#import "TimeEntryView.h"
// Models
#import "TimeEntryViewData.h"
// Protocols
#import "TimeEntryViewLayoutProtocol.h"
// Helpers
#import "TDHelper.h"
#import "UIColor+Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntryView() <TimeEntryViewLayoutProtocol>

@property (weak, nonatomic) UILabel *projectLabel;
@property (weak, nonatomic) UILabel *billedHoursLabel;
@property (nullable, weak, nonatomic) UILabel *plannedHoursLabel;
@property (nullable, weak, nonatomic) CALayer *plannedLayer;
@property (nullable, weak, nonatomic) CALayer *billedLayer;

/**
 Sets view up with given model's info.

 @param data Time entry view model to display.
 */
- (void)setupWithData:(TimeEntryViewData *)data;

@end

NS_ASSUME_NONNULL_END

@implementation TimeEntryView

#pragma mark - Lifecycle

+ (instancetype)entryWithData:(TimeEntryViewData *)data {
    TimeEntryView *timeEntryView = [[self alloc] initWithFrame:CGRectZero];
    [timeEntryView setupWithData:data];
    return timeEntryView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupInitially];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _billedLayer.frame = (CGRect){.size = {.width = CGRectGetWidth(self.bounds), .height = TDConstans.oneHourHeight}};
    _plannedLayer.frame = self.bounds;
}

#pragma mark - Private

- (void)setupWithData:(TimeEntryViewData *)data {
    self.backgroundColor = UIColor.td_projectColor;
    
    // Rounding max hours so we'll be getting height by oneHourHeight/2 portions as minimal step
    float maximumHours = data.maximumHours < 0.5f ? 0.5f : ceilf(data.maximumHours * 2.0f) / 2.0f;
    CGFloat height = MAX(TDConstans.oneHourHeight, maximumHours * TDConstans.oneHourHeight);
    
    if(data.plannedHours > 0.0f) {
        CALayer *containingLayer = CALayer.layer;
        containingLayer.cornerRadius = 10.0f;
        if (data.billedHours >= data.plannedHours) {
            // Indicate billed hours domination by darkening difference
            containingLayer.backgroundColor = [self.backgroundColor darkerColorByFactor: 0.1f].CGColor;
            if (data.billedHours == data.plannedHours) {
                height += TDConstans.minimalMargin / 2.0f;
            }
        } else {
            // Indicate planned hours domination by light patterning difference
            containingLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellPattern"]].CGColor;
            
            UILabel *plannedHoursLabel = [UILabel new];
            [self addSubview:plannedHoursLabel];
            self.plannedHoursLabel = plannedHoursLabel;
            _plannedHoursLabel.font = UIFont.td_plannedTimeEntrySubtitleFont;
            _plannedHoursLabel.textColor = UIColor.td_fadingWhiteColor;
            _plannedHoursLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self setupPlannedHoursConstraints];
            
            _plannedHoursLabel.text = data.plannedHoursString;
        }
        [self.layer insertSublayer:containingLayer atIndex:0];
        self.plannedLayer = containingLayer;
        
        CALayer *billedLayer = CALayer.layer;
        billedLayer.cornerRadius = 10.0f;
        billedLayer.backgroundColor = self.backgroundColor.CGColor;
        [self.layer insertSublayer:billedLayer above:_plannedLayer];
        self.billedLayer = billedLayer;
        
        
        // Indicating that some time has been planned
        if (height == TDConstans.oneHourHeight && data.plannedHours > 0.0f) {
            height += TDConstans.oneHourHeight / 2.0f;
        }
    }
    [self.heightAnchor constraintEqualToConstant:height].active = YES;
    
    _projectLabel.text = data.projectTitle;
    _billedHoursLabel.attributedText = data.billedTimeAttributedString;
}

#pragma mark - TimeEntryViewLayoutProtocol

- (void)setupInitially {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    UILabel *projectLabel = [UILabel new];
    [self addSubview:projectLabel];
    self.projectLabel = projectLabel;
    
    UILabel *billedHoursLabel = [UILabel new];
    [self addSubview:billedHoursLabel];
    self.billedHoursLabel = billedHoursLabel;
    
    _projectLabel.numberOfLines = 0;
    _projectLabel.font = UIFont.td_projectTitleFont;
    _projectLabel.textColor = UIColor.td_whiteColor;
    _projectLabel.translatesAutoresizingMaskIntoConstraints = NO;

    _billedHoursLabel.font = UIFont.td_billedTimeEntrySubtitleFont;
    _billedHoursLabel.textColor = UIColor.td_whiteColor;
    _billedHoursLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self setupInitialConstraints];
}

- (void)setupInitialConstraints {
    [_projectLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant: TDConstans.minimalMargin].active = YES;
    [self.trailingAnchor constraintGreaterThanOrEqualToAnchor:_projectLabel.trailingAnchor constant:TDConstans.minimalMargin].active = YES;
    [_projectLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:TDConstans.minimalMargin].active = YES;
    
    [_billedHoursLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant: TDConstans.minimalMargin].active = YES;
    [self.trailingAnchor constraintGreaterThanOrEqualToAnchor:_billedHoursLabel.trailingAnchor constant:TDConstans.minimalMargin].active = YES;
    [_billedHoursLabel.topAnchor constraintGreaterThanOrEqualToAnchor:_projectLabel.bottomAnchor constant:TDConstans.mediumMargin].active = YES;
    [self.bottomAnchor constraintGreaterThanOrEqualToAnchor:_billedHoursLabel.bottomAnchor constant:TDConstans.minimalMargin].active = YES;
}

- (void)setupPlannedHoursConstraints {
    [_billedHoursLabel.topAnchor constraintEqualToAnchor:_projectLabel.bottomAnchor constant:TDConstans.mediumMargin].active = YES;
    [_plannedHoursLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor
                                                     constant: TDConstans.minimalMargin].active = YES;
    [self.trailingAnchor constraintGreaterThanOrEqualToAnchor:_plannedHoursLabel.trailingAnchor
                                                     constant:TDConstans.minimalMargin].active = YES;
    [_plannedHoursLabel.topAnchor constraintGreaterThanOrEqualToAnchor:_billedHoursLabel.bottomAnchor constant:TDConstans.minimalMargin].active = YES;
    [self.bottomAnchor constraintGreaterThanOrEqualToAnchor:_plannedHoursLabel.bottomAnchor
                                                   constant:TDConstans.minimalMargin].active = YES;
}

@end
