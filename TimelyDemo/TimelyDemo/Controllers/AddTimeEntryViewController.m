//
//  AddTimeEntryViewController.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 13/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import "AddTimeEntryViewController.h"
// Models
#import "TimeEntryViewData.h"
// Views
#import "TimeEntryEditableView.h"
#import "DGActivityIndicatorView.h"
// Services
#import "PhotoCaptureService.h"
#import "TimeEntryRecognitionService.h"
// Helpers
#import "TDHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddTimeEntryViewController () <PhotoCaptureServiceDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmRecognitionButton;
@property (weak, nonatomic, nullable) UIStackView *addEntryStackView;
@property (weak, nonatomic, nullable) DGActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic, nullable) NSLayoutConstraint *addEntryBottomConstraint;

@property (strong, nonatomic) PhotoCaptureService *captureService;
@property (strong, nonatomic) TimeEntryRecognitionService *recognitionService;

/**
 Presents recognized entity to confirm its adding or decline, with animation.

 @param timeEntry Time entry to present visually.
 */
- (void)presentAddEntryViewFromEntry:(TimeEntry *)timeEntry;

/**
 Sets constraints up for presenting time entry to add.
 */
- (void)setupAddEntryConstraints;

/**
 Dismisses new entry adding camera controller.

 @param sender Close button.
 */
- (IBAction)closeButtonTapped:(UIButton *)sender;

/**
 Captures current camera frame and tries to recognize new time entry from it.

 @param sender Start recognizing button.
 */
- (IBAction)startRecognizingButtonTapped:(UIButton *)sender;

/**
 Rejects new entry with animation, makes capture button visible.

 @param sender Reject button.
 */
- (void)rejectButtonTapped:(UIButton *)sender;

/**
 Adds new time entry, broadcast it using Notification Center and dismisses new entry adding camera controller.

 @param sender Confirm button.
 */
- (void)confirmButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END

@implementation AddTimeEntryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captureService = [PhotoCaptureService new];
    _captureService.delegate = self;
    self.recognitionService = [TimeEntryRecognitionService new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AVCaptureVideoPreviewLayer *previewLayer = [_captureService startCamera];
    if (previewLayer) {
        previewLayer.frame = self.view.layer.bounds;
        [self.view.layer addSublayer:previewLayer];
    }
   
    [self.view bringSubviewToFront:_closeButton];
    [self.view bringSubviewToFront:_confirmRecognitionButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_captureService stopCamera];
}

#pragma mark - Private

- (void)presentAddEntryViewFromEntry:(TimeEntry *)timeEntry {
    TimeEntryViewData *data = [[TimeEntryViewData alloc] initWithTimeEntry:timeEntry];
    TimeEntryEditableView *entryView = [TimeEntryEditableView entryWithData:data];
    
    UIStackView *addEntryStackView = [UIStackView new];
    addEntryStackView.axis = UILayoutConstraintAxisVertical;
    addEntryStackView.spacing = 20.0f;
    
    [addEntryStackView addArrangedSubview:entryView];
    
    UIButton *declineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [declineButton setImage:[UIImage imageNamed:@"decline"] forState:UIControlStateNormal];
    [declineButton addTarget:self action:@selector(rejectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIStackView *buttonsStackView = [UIStackView new];
    buttonsStackView.axis = UILayoutConstraintAxisHorizontal;
    buttonsStackView.alignment = UIStackViewAlignmentCenter;
    buttonsStackView.distribution = UIStackViewDistributionFillEqually;
    [buttonsStackView addArrangedSubview:declineButton];
    [buttonsStackView addArrangedSubview:confirmButton];
    [addEntryStackView addArrangedSubview:buttonsStackView];
    
    addEntryStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:addEntryStackView];
    self.addEntryStackView = addEntryStackView;
    [self setupAddEntryConstraints];
    
    addEntryStackView.transform = CGAffineTransformTranslate(addEntryStackView.transform, 0, 44.0 + TDConstans.outerMargin * 2 + TDConstans.oneHourHeight);
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
             addEntryStackView.transform = CGAffineTransformIdentity;
         } completion:nil];
}

- (void)setupAddEntryConstraints {
    if (_addEntryStackView) {
        [_addEntryStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        NSLayoutConstraint *addEntryBottomConstraint = [_addEntryStackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-TDConstans.outerMargin];
        addEntryBottomConstraint.active = YES;
        self.addEntryBottomConstraint = addEntryBottomConstraint;
        [_addEntryStackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:TDConstans.outerMargin].active = YES;
        [_addEntryStackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-TDConstans.outerMargin].active = YES;
    }
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)closeButtonTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startRecognizingButtonTapped:(UIButton *)sender {
    if (TARGET_IPHONE_SIMULATOR || !_captureService.isPermissionGranted) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [_captureService captureImage];
        
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotateMultiple tintColor:UIColor.whiteColor size:44.0f];
        activityIndicatorView.frame = sender.frame;
        [self.view insertSubview:activityIndicatorView aboveSubview:sender];
        [activityIndicatorView startAnimating];
        self.activityIndicatorView = activityIndicatorView;
        
        [UIView transitionWithView:sender
                          duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            sender.hidden = YES;
                        }
                        completion:NULL];
    }
}

- (void)rejectButtonTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (_addEntryStackView) {
        self.addEntryStackView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.4
                              delay:0.0
             usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:0 animations:^{
                 self.addEntryStackView.transform = CGAffineTransformTranslate(self.addEntryStackView.transform, 0, CGRectGetHeight(self.addEntryStackView.frame) + TDConstans.outerMargin);
             } completion:^(BOOL finished) {
                 [self.addEntryStackView removeFromSuperview];
                 [UIView transitionWithView:self.confirmRecognitionButton
                                   duration:0.2
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^{
                                     self.confirmRecognitionButton.hidden = NO;
                                 } completion:nil];
             }];
    }
}

- (void)confirmButtonTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (_addEntryStackView) {
        [UIView animateWithDuration:0.4
                              delay:0.0
             usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:0 animations:^{
                 self.addEntryStackView.transform = CGAffineTransformTranslate(self.addEntryStackView.transform, 0, CGRectGetHeight(self.addEntryStackView.frame) + TDConstans.outerMargin);
             } completion:^(BOOL finished) {
                 TimeEntryEditableView *entryView = self.addEntryStackView.arrangedSubviews.firstObject;
                 if([entryView isKindOfClass:TimeEntryEditableView.self]) {
                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:entryView.data.timeEntry forKey:TDTimeEntryKey];
                     [[NSNotificationCenter defaultCenter] postNotificationName:TDTimeEntryAddedNotificationName object:nil userInfo:userInfo];
                 }
                 [self.addEntryStackView removeFromSuperview];
                 [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
             }];
    }
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect newFrame = [self.view convertRect:frame fromView:UIApplication.sharedApplication.delegate.window];
    self.addEntryBottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(self.view.frame) - TDConstans.outerMargin;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.addEntryBottomConstraint.constant = -TDConstans.outerMargin;
    [self.view layoutIfNeeded];
}

#pragma mark - PhotoCaptureServiceDelegate

- (void)didCaptureImage:(UIImage *)image {
    [_recognitionService recognizeTextFromImage:image completion:^(TimeEntry * _Nullable timeEntry, NSError * _Nullable error) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
        
        if (timeEntry) {
            [self presentAddEntryViewFromEntry:timeEntry];
        } else {
            [UIView transitionWithView:self.confirmRecognitionButton
                              duration:0.2
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.confirmRecognitionButton.hidden = NO;
                            } completion:nil];
        }
    }];
}

@end
