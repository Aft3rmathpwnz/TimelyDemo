//
//  HoursViewController.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 08/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Controllers
#import "HoursViewController.h"
#import "TimeEntriesViewController.h"
#import "DayMenuViewController.h"
// Views
#import "CBZSplashView.h"
// Services
#import "TimeEntriesService.h"
// Helpers
#import "TDHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoursViewController ()

@property (weak, nonatomic, nullable) TimeEntriesViewController *timeEntriesViewController;
@property (weak, nonatomic, nullable) DayMenuViewController *dayMenuViewController;
@property (strong, nonatomic, nullable) NSArray<TimeEntry *> *timeEntries;
@property (strong, nonatomic) TimeEntriesService *timeEntriesService;

/**
 Sets splash screen up to be animated once entries got returned by TimeEntriesService instance.

 @return CBZSplashView instance which contains splash icon to animate;
 */
- (CBZSplashView *)setupSplashScreen;

/**
 Must be called when new time entry added using KVO.
 
 @param notification Contains new TimeEntry object by TDTimeEntryKey key.
 */
- (void)timeEntryAdded:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END

@implementation HoursViewController

#pragma mark - Properties

- (void)setTimeEntries:(NSArray<TimeEntry *> *)timeEntries {
    if (![_timeEntries isEqual:timeEntries]) {
        _timeEntries = timeEntries;
        [_timeEntriesViewController setupWithTimeEntries:_timeEntries];
        [_dayMenuViewController setupWithTimeEntries:_timeEntries];
    }
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeEntriesService = [TimeEntriesService new];
    CBZSplashView *splashView = [self setupSplashScreen];
    [self.view addSubview:splashView];
    [_timeEntriesService asyncGetTimeEntriesWithCompletion:^(NSArray<TimeEntry *> * _Nullable timeEntries, NSError * _Nullable error) {
        if (timeEntries) {
            self.timeEntries = [NSArray arrayWithArray:timeEntries];
        }
        [splashView startAnimation];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeEntryAdded:) name:TDTimeEntryAddedNotificationName object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationController = segue.destinationViewController;
    if ([destinationController isKindOfClass:TimeEntriesViewController.self]) {
        self.timeEntriesViewController = (TimeEntriesViewController *)destinationController;
    } else if([destinationController isKindOfClass:DayMenuViewController.self]) {
        self.dayMenuViewController = (DayMenuViewController *)destinationController;
    }
}

#pragma mark - Private

- (CBZSplashView *)setupSplashScreen {
    UIImage *icon = [UIImage imageNamed:@"start_logo"];
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:nil];
    splashView.layer.contents = (id)[UIImage imageNamed:@"launch_background"].CGImage;
    splashView.iconStartSize = icon.size;
    splashView.animationDuration = 0.5f;
    return splashView;
}

- (void)timeEntryAdded:(NSNotification *)notification {
    TimeEntry *addedTimeEntry = [notification.userInfo valueForKey:TDTimeEntryKey];
    if (addedTimeEntry) {
        self.timeEntries = [_timeEntries arrayByAddingObject:addedTimeEntry];
    }
}

@end
