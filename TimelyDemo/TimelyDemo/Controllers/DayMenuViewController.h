//
//  DayMenuViewController.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 12/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeEntry;

NS_ASSUME_NONNULL_BEGIN

@interface DayMenuViewController : UIViewController

/**
 Calculates and displays day's total hours & earnings.

 @param timeEntries Time entries to be calculated.
 */
- (void)setupWithTimeEntries:(nullable NSArray<TimeEntry *> *)timeEntries;

@end

NS_ASSUME_NONNULL_END
