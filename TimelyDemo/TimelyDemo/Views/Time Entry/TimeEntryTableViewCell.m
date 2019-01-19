//
//  TimeEntryTableViewCell.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Views
#import "TimeEntryTableViewCell.h"
#import "TimeEntryView.h"
// Helpers
#import "TDHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntryTableViewCell ()

@property (weak, nonatomic) TimeEntryView *timeEntryView;

- (void)setupConstraints;

@end

NS_ASSUME_NONNULL_END

@implementation TimeEntryTableViewCell

#pragma mark - Public

- (void)setupTimeEntryView:(TimeEntryView *)timeEntryView {
    if (![timeEntryView isEqual:_timeEntryView]) {
        [_timeEntryView removeFromSuperview];
        timeEntryView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:timeEntryView];
        self.timeEntryView = timeEntryView;
        [self setupConstraints];
    }
}

#pragma mark - Private

- (void)setupConstraints {
    [_timeEntryView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:TDConstans.outerMargin].active = YES;
    [_timeEntryView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-TDConstans.outerMargin].active = YES;
    [_timeEntryView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:TDConstans.minimalMargin].active = YES;
    NSLayoutConstraint *bottomConstraint = [_timeEntryView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:0.0f];
    // Table view cell UIView-Encapsulated-Layout-Height constraint conflict bug fix
    // https://stackoverflow.com/questions/25059443/what-is-nslayoutconstraint-uiview-encapsulated-layout-height-and-how-should-i
    bottomConstraint.priority = 999.0f;
    bottomConstraint.active = YES;
}

@end
