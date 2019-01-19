//
//  TDConstants.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import UIKit;

extern NSString *const TDTimeEntryAddedNotificationName;
extern NSString *const TDTimeEntryKey;

@interface UIColor (TimelyDemo)

+ (UIColor *)td_darkColor;
+ (UIColor *)td_whiteColor;
+ (UIColor *)td_fadingWhiteColor;
+ (UIColor *)td_grayColor;
+ (UIColor *)td_projectColor;

@end

@interface UIFont (TimelyDemo)

+ (UIFont *)td_projectTitleFont;
+ (UIFont *)td_billedTimeEntrySubtitleFont;
+ (UIFont *)td_plannedTimeEntrySubtitleFont;

@end

@interface TDConstans: NSObject

+ (CGFloat)minimalMargin;
+ (CGFloat)mediumMargin;
+ (CGFloat)maximalMargin;
+ (CGFloat)outerMargin;
+ (CGFloat)oneHourHeight;
+ (NSUInteger)hourlyRate;

@end

@interface TDHelperFunctions : NSObject

/**
 Extracting integer hours and minutes components from time interval in seconds.

 @param hours Reference to integer hours variable that will be filled with extracted hours.
 @param minutes Reference to integer minutes variable that will be filled with extracted hours.
 @param timeInterval Time interval in seconds.
 */
+ (void)extractHours:(NSUInteger *)hours minutes:(NSUInteger *)minutes fromTimeInterval:(NSTimeInterval)timeInterval;

@end

