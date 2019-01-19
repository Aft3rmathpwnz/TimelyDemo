//
//  DayMenuViewController.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 12/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Controllers
#import "DayMenuViewController.h"
#import "AddTimeEntryViewController.h"
// Views
#import "DayMenuView.h"
// Models
#import "DayMenuViewData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DayMenuViewController () <DayMenuViewDelegate>

@property (weak, nonatomic) IBOutlet DayMenuView *dayMenuView;

@end

NS_ASSUME_NONNULL_END

@implementation DayMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _dayMenuView.delegate = self;
}

#pragma mark - Public

- (void)setupWithTimeEntries:(NSArray<TimeEntry *> *)timeEntries {
    DayMenuViewData *dayMenuViewData = [[DayMenuViewData alloc] initWithTimeEntries:timeEntries];
    [_dayMenuView setupWithData:dayMenuViewData];
}

#pragma mark - DayMenuViewDelegate

- (void)didTapAdd {
    AddTimeEntryViewController *addTimeEntryViewController = [AddTimeEntryViewController new];
    [self.parentViewController presentViewController:addTimeEntryViewController animated:YES completion:nil];
}

@end
