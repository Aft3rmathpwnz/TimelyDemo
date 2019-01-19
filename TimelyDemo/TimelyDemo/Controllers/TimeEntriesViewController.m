//
//  TimeEntriesViewController.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Controllers
#import "TimeEntriesViewController.h"
// Views
#import "TimeEntryView.h"
#import "TDSeparatorTableView.h"
#import "TimeEntryTableViewCell.h"
// Models
#import "TimeEntryViewData.h"
// Helpers
#import "TDHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntriesViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet TDSeparatorTableView *tableView;
@property (strong, nonatomic) NSArray<TimeEntryViewData *> *timeEntriesViewData;

@end

NS_ASSUME_NONNULL_END

@implementation TimeEntriesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.contentInset = (UIEdgeInsets){ .bottom = TDConstans.mediumMargin };
    [_tableView registerClass:TimeEntryTableViewCell.self forCellReuseIdentifier:NSStringFromClass(TimeEntryTableViewCell.self)];
}

#pragma mark - Private

- (void)setupWithTimeEntries:(NSArray<TimeEntry *> *)timeEntries {
    NSMutableArray <TimeEntryViewData *> *tempEntriesViewData = [NSMutableArray array];
    for (TimeEntry *timeEntry in timeEntries) {
        TimeEntryViewData *data = [[TimeEntryViewData alloc] initWithTimeEntry:timeEntry];
        [tempEntriesViewData addObject:data];
    }
    self.timeEntriesViewData = [NSArray arrayWithArray:tempEntriesViewData];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimeEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TimeEntryTableViewCell.class) forIndexPath:indexPath];
    TimeEntryView *entryView = [TimeEntryView entryWithData:_timeEntriesViewData[indexPath.row]];
    [cell setupTimeEntryView:entryView];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timeEntriesViewData.count;
}

@end
