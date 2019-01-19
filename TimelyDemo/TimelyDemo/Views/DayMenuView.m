//
//  DayMenuView.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 12/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Views
#import "DayMenuView.h"
// Models
#import "DayMenuViewData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DayMenuView ()

@property (weak, nonatomic) IBOutlet UILabel *dateEarningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHoursLabel;

@end

NS_ASSUME_NONNULL_END

@implementation DayMenuView

#pragma mark - Public

- (void)setupWithData:(DayMenuViewData *)data {
    _dateEarningsLabel.attributedText = data.dateEarningsAttributedString;
    _totalHoursLabel.text = data.totalHoursString;
}

#pragma mark - DayMenuViewDelegate

- (IBAction)addButtonTapped:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(didTapAdd)]) {
        [_delegate didTapAdd];
    }
}


@end
