//
//  TimeEntry.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN


/**
 PONSO for time entry entity (must be implementing NSCoding & NSCopying to be serializable)
 */
@interface TimeEntry : NSObject

@property (copy, nonatomic) NSString *projectName;
@property (assign, nonatomic) NSTimeInterval billedTimeInterval;
@property (assign, nonatomic) NSTimeInterval plannedTimeInterval;

@end

NS_ASSUME_NONNULL_END
