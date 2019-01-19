//
//  TimeEntryView.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeEntryViewData;

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntryView: UIView

- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute((unavailable("Please use +entryWithData: instead.")));
- (instancetype)initWithFrame:(CGRect)frame __attribute((unavailable("Please use +entryWithData: instead.")));
- (instancetype)init __attribute((unavailable("Please use +entryWithData: instead.")));

/**
 Creates view containing immutable time entry info.

 @param data Time entry view data containing info.
 @return Time entry view filled with given data.
 */
+ (instancetype)entryWithData:(TimeEntryViewData *)data;


@end

NS_ASSUME_NONNULL_END
