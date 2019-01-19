//
//  TimeEntryRecognitionService.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 18/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import UIKit;
@class TimeEntry;

NS_ASSUME_NONNULL_BEGIN

typedef void (^TimeEntryRecognitionCallback)(TimeEntry *_Nullable timeEntry, NSError *_Nullable error);

@interface TimeEntryRecognitionService : NSObject

/**
 Recognizes project name and/or hours and minutes from the image and constructs time entry from it.
 For demo project recignizes only images captured in portrait mode; image orientation to be investigated.

 @param image UIImage to recognize on.
 @param completion Callback with time entry if recognized succesfully, or error if any otherwise.
 */
- (void)recognizeTextFromImage:(UIImage *)image completion:(TimeEntryRecognitionCallback)completion;

@end

NS_ASSUME_NONNULL_END
