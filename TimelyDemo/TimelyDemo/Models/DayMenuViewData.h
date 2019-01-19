//
//  DayMenuViewData.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 12/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimeEntry;

NS_ASSUME_NONNULL_BEGIN

@interface DayMenuViewData : NSObject

@property (copy, readonly, nonatomic) NSAttributedString *dateEarningsAttributedString;
@property (copy, readonly, nonatomic) NSString *totalHoursString;

- (instancetype)init __attribute((unavailable("Use -initWithTimeEntries: instead")));
/**
 Initializes model for day menu view that contains string representations of total hours and earnings.
 Should be used this one.

 @param timeEntries Time entries for one day.
 @return Day menu view model with calculated hours and earnings.
 */
- (instancetype)initWithTimeEntries:(nullable NSArray<TimeEntry *> *)timeEntries NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
