//
//  DayMenuView.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 12/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import UIKit;
#import "XibView.h"
@class DayMenuViewData;

NS_ASSUME_NONNULL_BEGIN

@protocol DayMenuViewDelegate <NSObject>

/**
 Called when the add button has been tapped.
 */
- (void)didTapAdd;

@end

@interface DayMenuView : XibView

@property (weak, nonatomic, nullable) id<DayMenuViewDelegate> delegate;

/**
 Displays current day's total hours, earnings and date.

 @param data Data containing string representations of total hours and earnings.
 */
- (void)setupWithData:(DayMenuViewData *)data;

@end

NS_ASSUME_NONNULL_END
