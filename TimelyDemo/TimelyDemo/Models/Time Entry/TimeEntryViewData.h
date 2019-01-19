//
//  TimeEntryViewData.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import UIKit;
@class TimeEntry;

NS_ASSUME_NONNULL_BEGIN

// In real project there may be a protocol to support modularity of data visual representation logic.
@interface TimeEntryViewData : NSObject

@property (copy, readonly, nonatomic) NSString *projectTitle;
@property (copy, readonly, nonatomic) NSAttributedString *billedTimeAttributedString;
@property (nullable, copy, readonly, nonatomic) NSString *plannedHoursString;
@property (assign, readonly, nonatomic) float billedHours;
@property (assign, readonly, nonatomic) float plannedHours;
/**
 Maximum of billed and planned hours for time entry
 */
@property (assign, readonly, nonatomic) float maximumHours;
@property (assign, readonly, nonatomic) NSString *spentTimeString;
@property (assign, readonly, nonatomic) TimeEntry *timeEntry;

- (instancetype)init __attribute((unavailable("Use -initWithTimeEntry: instead")));
- (instancetype)initWithTimeEntry:(TimeEntry *)timeEntry;
- (instancetype)initWithProjectTitle:(nullable NSString *)projectTitle
         billedHoursAttributedString:(NSAttributedString *)billedHoursAttributedString;

@end

NS_ASSUME_NONNULL_END
