//
//  TimeEntriesViewController.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeEntry;

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntriesViewController : UIViewController

/**
 Displays time entries' data.
 
 @param timeEntries Time entries that must be presented.
 */
- (void)setupWithTimeEntries:(nullable NSArray<TimeEntry *> *)timeEntries;

@end

NS_ASSUME_NONNULL_END
