//
//  TimeEntryEditableView.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 13/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

// Views
#import "TimeEntryEditableView.h"
// Models
#import "TimeEntryViewData.h"
// Protocols
#import "TimeEntryViewLayoutProtocol.h"
// Helpers
#import "TDHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntryEditableView () <UITextFieldDelegate, TimeEntryViewLayoutProtocol>

@property (weak, nonatomic) UITextField *projectTextField;
@property (weak, nonatomic) UITextField *spentHoursTextField;

/**
 Sets view up with given model's info.
 
 @param data Time entry view model to display.
 */
- (void)setupWithData:(TimeEntryViewData *)data;

@end

NS_ASSUME_NONNULL_END

@implementation TimeEntryEditableView
@dynamic data;

#pragma mark - Properties

- (TimeEntryViewData *)data {
    return [[TimeEntryViewData alloc] initWithProjectTitle:_projectTextField.text billedHoursAttributedString:_spentHoursTextField.attributedText];
}

#pragma mark - Lifecycle

+ (instancetype)entryWithData:(TimeEntryViewData *)data {
    TimeEntryEditableView *timeEntryEditableView = [[self alloc] init];
    [timeEntryEditableView setupWithData:data];
    return timeEntryEditableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupInitially];
    }
    return self;
}

#pragma mark - Private

- (void)setupWithData:(TimeEntryViewData *)data {
    self.backgroundColor = UIColor.td_projectColor;
    _projectTextField.text = data.projectTitle;
    _spentHoursTextField.text = data.spentTimeString;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TimeEntryViewLayoutProtocol

- (void)setupInitially {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    UITextField *projectTextField = [UITextField new];
    [self addSubview:projectTextField];
    projectTextField.delegate = self;
    self.projectTextField = projectTextField;
    
    UITextField *billedHoursTextField = [UITextField new];
    [self addSubview:billedHoursTextField];
    billedHoursTextField.delegate = self;
    self.spentHoursTextField = billedHoursTextField;
        
    _projectTextField.font = UIFont.td_projectTitleFont;
    _projectTextField.textColor = UIColor.td_whiteColor;
    _projectTextField.translatesAutoresizingMaskIntoConstraints = NO;

    _spentHoursTextField.font = UIFont.td_billedTimeEntrySubtitleFont;
    _spentHoursTextField.textColor = UIColor.td_whiteColor;
    _spentHoursTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setupInitialConstraints];
}

- (void)setupInitialConstraints {
    [_projectTextField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant: TDConstans.minimalMargin].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:_projectTextField.trailingAnchor constant:TDConstans.minimalMargin].active = YES;
    [_projectTextField.topAnchor constraintEqualToAnchor:self.topAnchor constant:TDConstans.minimalMargin].active = YES;
    
    
    [_spentHoursTextField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant: TDConstans.minimalMargin].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:_spentHoursTextField.trailingAnchor constant:TDConstans.minimalMargin].active = YES;
    [_spentHoursTextField.topAnchor constraintGreaterThanOrEqualToAnchor:_projectTextField.bottomAnchor constant:TDConstans.mediumMargin].active = YES;
    [self.bottomAnchor constraintGreaterThanOrEqualToAnchor:_spentHoursTextField.bottomAnchor constant:TDConstans.minimalMargin].active = YES;
}

@end
