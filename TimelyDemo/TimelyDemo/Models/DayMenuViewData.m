//
//  DayMenuViewData.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 12/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Models
#import "DayMenuViewData.h"
#import "TimeEntry.h"
// Helpers
#import "TDHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface DayMenuViewData ()

/**
 Calculates total earnings for current day.

 @param timeEntries Time entries for day that must be calculated.
 @return Attributed string representation of current day total earnings, e.g. "Thu, Jan 17, €337.50"
 */
- (NSAttributedString *)dateEarningsAttributedStringWithTimeEntries:(nullable NSArray<TimeEntry *> *)timeEntries;

/**
 Calculates total billed hours for current day.

 @param timeEntries Time entries for day that must be calculated.
 @return String representation of current day total billed hours, e.g. "13h 30m"
 */
- (NSString *)totalHoursStringWithTimeEntries:(nullable NSArray<TimeEntry *> *)timeEntries;

@end

NS_ASSUME_NONNULL_END

@implementation DayMenuViewData

#pragma mark - Lifecycle

- (instancetype)initWithTimeEntries:(NSArray<TimeEntry *> *)timeEntries {
    if (self = [super init]) {
        _dateEarningsAttributedString = [self dateEarningsAttributedStringWithTimeEntries:timeEntries];
        _totalHoursString = [self totalHoursStringWithTimeEntries:timeEntries];
    }
    return self;
}

#pragma mark - Private

- (NSAttributedString *)dateEarningsAttributedStringWithTimeEntries:(NSArray<TimeEntry *> *)timeEntries {
    // Calculating total earnings
    float amount = 0;
    for (TimeEntry *timeEntry in timeEntries) {
        float billedHours = timeEntry.billedTimeInterval / 60.0f / 60.0f;
        amount += billedHours * TDConstans.hourlyRate;
    }
    NSString *amountString = [NSString stringWithFormat:@"€%.2f", amount];
    
    NSDateFormatter *dateFormatter= [NSDateFormatter new];
    [dateFormatter setLocale: NSLocale.currentLocale];
    [dateFormatter setDateFormat:@"E, MMM dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    // Attributing earnings with different style than date
    NSMutableAttributedString *dateEarningsAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@, %@", dateString, amountString] attributes:@{NSFontAttributeName : UIFont.td_projectTitleFont, NSForegroundColorAttributeName:UIColor.td_darkColor}];
    [dateEarningsAttributedString addAttributes:@{NSFontAttributeName : UIFont.td_billedTimeEntrySubtitleFont, NSForegroundColorAttributeName:UIColor.td_grayColor} range:[dateEarningsAttributedString.string rangeOfString:[NSString stringWithFormat:@", %@", amountString]]];
    
    return dateEarningsAttributedString;
}

- (NSString *)totalHoursStringWithTimeEntries:(NSArray<TimeEntry *> *)timeEntries {
    // Calculating total hours
    float totalIntervals = 0;
    for (TimeEntry *timeEntry in timeEntries) {
        float entryInterval = timeEntry.billedTimeInterval;
        totalIntervals += entryInterval;
    }
    
    NSUInteger hours, minutes;
    [TDHelperFunctions extractHours:&hours minutes:&minutes fromTimeInterval:totalIntervals];
    
    return [NSString stringWithFormat:@"%01tuh %02tum", hours, minutes];
}

@end
