//
//  TDConstants.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import "TDHelper.h"
#import "UIColor+Utils.h"

NSString *const TDTimeEntryAddedNotificationName = @"TimeEntryAddedNotification";
NSString *const TDTimeEntryKey = @"timeEntry";

@implementation UIColor (TimelyDemo)

+ (UIColor *)td_darkColor {
    return [UIColor colorwithHexString:@"#373E44"];
}

+ (UIColor *)td_whiteColor {
    return UIColor.whiteColor;
}

+ (UIColor *)td_fadingWhiteColor {
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

+ (UIColor *)td_grayColor {
    return [UIColor colorwithHexString:@"#A0A4A5"];
}

+ (UIColor *)td_projectColor {
    return [UIColor colorwithHexString:@"49B27C"];
}

@end

@implementation UIFont (TimelyDemo)

+ (UIFont *)td_projectTitleFont {
    return [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)td_billedTimeEntrySubtitleFont {
    return [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
}

+ (UIFont *)td_plannedTimeEntrySubtitleFont {
    return [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
}

@end

@implementation TDConstans

+ (CGFloat)minimalMargin {
    return 12.0f;
}

+ (CGFloat)mediumMargin {
    return 24.0f;
}

+ (CGFloat)outerMargin {
    return 20.0f;
}

+ (CGFloat)maximalMargin {
    return 32.0f;
}

+ (CGFloat)oneHourHeight {
    return 80.0f;
}

+ (NSUInteger)hourlyRate {
    return 25;
}

@end

@implementation TDHelperFunctions

+ (void)extractHours:(NSUInteger *)hours minutes:(NSUInteger *)minutes fromTimeInterval:(NSTimeInterval)timeInterval {
    NSUInteger integerInterval = (NSUInteger)timeInterval;
    *minutes = (integerInterval / 60) % 60;
    *hours = (integerInterval / 3600);
}

@end
