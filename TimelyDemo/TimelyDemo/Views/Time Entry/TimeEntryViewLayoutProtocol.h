//
//  TimeEntryViewLayoutProtocol.h
//  TimelyDemo
//
//  Created by Aft3rmath on 18/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TimeEntryViewLayoutProtocol <NSObject>

/**
 Sets project and billed hours labels up for default state
 */
- (void)setupInitially;

/**
 Sets project and billed hours labels constraints up for default state
 */
- (void)setupInitialConstraints;

@optional
/**
 Sets planned hours label related constraints up
 */
- (void)setupPlannedHoursConstraints;

@end

NS_ASSUME_NONNULL_END
