//
//  TimeEntriesService.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 15/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import "TimeEntriesService.h"
#import "TimeEntry.h"

@interface TimeEntriesService ()

@property (assign, readonly, nonatomic) NSArray<TimeEntry *> *timeEntries;

@end

@implementation TimeEntriesService

#pragma mark - Properties

- (NSArray<TimeEntry *> *)timeEntries {
    NSArray *times = @[
                       @{@"billed": @0.0, @"planned": @900.0},
                       @{@"billed": @3600.0, @"planned": @0.0},
                       @{@"billed": @3600.0, @"planned": @3600.0},
                       @{@"billed": @5400.0, @"planned": @3600.0},
                       @{@"billed": @3600.0, @"planned": @5400.0},
                       @{@"billed": @1800.0, @"planned": @14400.0},
                       @{@"billed": @0.0, @"planned": @0.0},
                       @{@"billed": @7200.0, @"planned": @0.0},
                       @{@"billed": @10800.0, @"planned": @900.0},
                       @{@"billed": @3600.0, @"planned": @4500.0},
                       @{@"billed": @3600.0, @"planned": @5400.0},
                       @{@"billed": @4500.0, @"planned": @3600.0},
                       @{@"billed": @900.0, @"planned": @0.0}
                       ];
    
    NSMutableArray <TimeEntry *> *entries = [NSMutableArray array];
    for (NSDictionary *time in times) {
        TimeEntry *entry = [TimeEntry new];
        entry.projectName = @"My First Project";
        entry.billedTimeInterval = [time[@"billed"] doubleValue];
        entry.plannedTimeInterval = [time[@"planned"] doubleValue];
        [entries addObject:entry];
    }
    return entries;
}

#pragma mark - Public

- (void)asyncGetTimeEntriesWithCompletion:(void (^)(NSArray<TimeEntry *> * _Nullable, NSError * _Nullable))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(self.timeEntries, nil);
    });
}

@end
