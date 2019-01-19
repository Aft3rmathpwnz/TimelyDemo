//
//  TimeEntriesService.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 15/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimeEntry;

NS_ASSUME_NONNULL_BEGIN

/**
 Mock for network service, that would perform CRUD operations with TimeEntry entity using APIClient if there was one.
 */
@interface TimeEntriesService : NSObject

- (void)asyncGetTimeEntriesWithCompletion:(nullable void (^)(NSArray<TimeEntry *> * _Nullable timeEntries, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
