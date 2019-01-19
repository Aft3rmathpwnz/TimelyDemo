//
//  TimeEntryTableViewCell.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import UIKit;
@class TimeEntryView;

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntryTableViewCell : UITableViewCell

/**
 Displays time entry view.
 
 @param timeEntryView View containing representations of total hours and earnings.
 */
- (void)setupTimeEntryView:(TimeEntryView *)timeEntryView;

@end

NS_ASSUME_NONNULL_END
