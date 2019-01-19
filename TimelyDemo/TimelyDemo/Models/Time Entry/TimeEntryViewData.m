//
//  TimeEntryViewData.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import UIKit;
// Models
#import "TimeEntryViewData.h"
#import "TimeEntry.h"
// Helpers
#import "TDHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntryViewData ()

/**
 Extracts billed time as hours.
 
 @param billedString String representation of day's billed time, e.g. "2h 30m".
 @return Floating hours value, e.g. 1.33.
 */
- (float)hoursFromBilledString:(NSString *)billedString;

/**
 Constructs attributed string representation of billed time and earned money for it.
 
 @param timeInterval Time interval in seconds that must be represented.
 @param rate Salary rate per hour, for demo app constantly 25€.
 @return Attributed string of billed time and earned money, e.g. "1h 30m - 37.5€".
 */
- (NSAttributedString *)billedTimeWithTimeInterval:(NSTimeInterval)timeInterval rate:(NSUInteger)rate;

/**
 Constructs string representation of spent time.

 @param timeInterval Time interval in seconds that must be represented.
 @return String of spent time, e.g. "1h 30m".
 */
- (NSString *)spentTimeWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 Constructing string representation of planned time.
 
 @param timeInterval Time interval that has been planned, in seconds.
 @return String representation of planned time, e.g. "2h 00m".
 */
- (NSString *)plannedTimeWithTimeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END

@implementation TimeEntryViewData
@dynamic maximumHours, timeEntry;

#pragma mark - Properties

- (float)maximumHours {
    return MAX(_billedHours, _plannedHours);
}

- (TimeEntry *)timeEntry {
    TimeEntry *timeEntry = [[TimeEntry alloc] init];
    timeEntry.projectName = _projectTitle;
    timeEntry.billedTimeInterval = _billedHours * 60.0f * 60.0f;
    timeEntry.plannedTimeInterval = _plannedHours * 60.0f * 60.0f;
    return timeEntry;
}

#pragma mark - Lifecycle

- (instancetype)initWithTimeEntry:(TimeEntry *)timeEntry {
    if (self = [super init]) {
        _projectTitle = [timeEntry.projectName copy];
        
        NSUInteger hours, minutes;
        // Forming billed hours string representation
        [TDHelperFunctions extractHours:&hours minutes:&minutes fromTimeInterval:timeEntry.billedTimeInterval];
        _billedHours = hours + minutes / 60.0;
        _billedTimeAttributedString = [self billedTimeWithTimeInterval:timeEntry.billedTimeInterval rate:TDConstans.hourlyRate];
        _spentTimeString = [self spentTimeWithTimeInterval:timeEntry.billedTimeInterval];
        
        // Forming planned hours string representation
        [TDHelperFunctions extractHours:&hours minutes:&minutes fromTimeInterval:timeEntry.plannedTimeInterval];
        _plannedHours = hours + minutes / 60.0;
        if(timeEntry.plannedTimeInterval > timeEntry.billedTimeInterval) {
            _plannedHoursString = [self plannedTimeWithTimeInterval:timeEntry.plannedTimeInterval];
        }
    }
    return self;
}

- (instancetype)initWithProjectTitle:(NSString *)projectTitle
         billedHoursAttributedString:(NSAttributedString *)billedHoursAttributedString {
    if (self = [super init]) {
        _projectTitle = [projectTitle copy];
        _billedTimeAttributedString = [billedHoursAttributedString copy];
        _billedHours = [self hoursFromBilledString:_billedTimeAttributedString.string];
    }
    return self;
}

#pragma mark - Private

- (float)hoursFromBilledString:(NSString *)billedString {
    // Getting ["Xh", "Ym"] string array
    NSArray<NSString *> *hoursAndMinutes = [billedString componentsSeparatedByString:@" "];
    // Getting "X" string
    NSString *cleanedHoursString = hoursAndMinutes.firstObject;
    if (cleanedHoursString.length > 0) {
        cleanedHoursString = [[cleanedHoursString componentsSeparatedByCharactersInSet:
                               [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                              componentsJoinedByString:@""];
    }
    if (cleanedHoursString.length == 0) {
        cleanedHoursString = @"0";
    }
    // Getting "Y" string
    
    NSString *cleanedMinutesString = hoursAndMinutes.lastObject;
    if (cleanedMinutesString.length > 0) {
        cleanedMinutesString = [[cleanedMinutesString componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                componentsJoinedByString:@""];
    }
    if (cleanedMinutesString.length == 0) {
        cleanedMinutesString = @"0";
    }
    
    return cleanedHoursString.doubleValue + cleanedMinutesString.doubleValue / 60.0f;
}

- (NSAttributedString *)billedTimeWithTimeInterval:(NSTimeInterval)timeInterval rate:(NSUInteger)rate {
    NSUInteger hours, minutes;
    [TDHelperFunctions extractHours:&hours minutes:&minutes fromTimeInterval:timeInterval];
    
    if(rate > 0) {
        // Constructing attributed string of spent time and earned money
        float earnings = (hours + ((float)minutes / 60.0)) * rate;
        NSMutableAttributedString *attributedBilledTimeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%01tuh %02tum - €%.2f", hours, minutes, earnings] attributes:@{NSFontAttributeName : UIFont.td_billedTimeEntrySubtitleFont, NSForegroundColorAttributeName:UIColor.td_whiteColor}];
        NSUInteger earningsStartLocation = [attributedBilledTimeString.string rangeOfString:@"-"].location;
        NSUInteger earningsLength = [attributedBilledTimeString.string componentsSeparatedByString:@"-"].lastObject.length + 1;

        [attributedBilledTimeString addAttribute: NSForegroundColorAttributeName value: UIColor.td_fadingWhiteColor range: NSMakeRange(earningsStartLocation, earningsLength)];

        return attributedBilledTimeString;
    } else {
        // Constructing string of spent time
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%01tuh %02tum", hours, minutes] attributes:@{NSFontAttributeName : UIFont.td_billedTimeEntrySubtitleFont, NSForegroundColorAttributeName: UIColor.td_whiteColor}];
    }
}

- (NSString *)spentTimeWithTimeInterval:(NSTimeInterval)timeInterval {
    NSUInteger hours, minutes;
    [TDHelperFunctions extractHours:&hours minutes:&minutes fromTimeInterval:timeInterval];
    // Constructing string of spent time
    return [NSString stringWithFormat:@"%01tuh %02tum", hours, minutes];
}

- (NSString *)plannedTimeWithTimeInterval:(NSTimeInterval)timeInterval {
    NSUInteger hours, minutes;
    [TDHelperFunctions extractHours:&hours minutes:&minutes fromTimeInterval:timeInterval];
    return [NSString stringWithFormat:@"Planned %01tuh %02tum", hours, minutes];
}

@end
