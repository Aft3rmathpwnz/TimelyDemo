//
//  TimeEntryRecognitionService.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 18/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import "TimeEntryRecognitionService.h"
// Models
#import "TimeEntry.h"
// Helpers
#import "UIImage+Utils.h"
// Frameworks
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface TimeEntryRecognitionService ()

/**
 Parses recognized text, tries to extract project name and/or spent hours and minutes.

 @param recognizedText Text to parse.
 @return Time entry if parsing was successful.
 */
- (TimeEntry *)parseTimeEntryFromText:(NSString *)recognizedText;

@end

NS_ASSUME_NONNULL_END

@implementation TimeEntryRecognitionService

#pragma mark - Public

- (void)recognizeTextFromImage:(UIImage *)image completion:(TimeEntryRecognitionCallback)completion {
    FIRVision *vision = [FIRVision vision];
    FIRVisionTextRecognizer *textRecognizer = [vision onDeviceTextRecognizer];
    FIRVisionImage *visionImage = [[FIRVisionImage alloc] initWithImage:[image fixedOrientation]];

    [textRecognizer processImage:visionImage
                      completion:^(FIRVisionText *_Nullable result,
                                   NSError *_Nullable error) {
                          if (error != nil || result == nil) {
                              completion(nil, error);
                              return;
                          }
                          TimeEntry *entry = [self parseTimeEntryFromText:result.text];
                          completion(entry, nil);
                      }];
}

#pragma mark - Private

- (TimeEntry *)parseTimeEntryFromText:(NSString *)recognizedText {
    NSMutableCharacterSet *projectNameCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [projectNameCharacterSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    NSLog(@"recognizedText = %@", recognizedText);
    NSScanner *scanner = [NSScanner scannerWithString:recognizedText];
    scanner.caseSensitive = NO;
    // Extracting project name
    NSString *projectNameString;
    [scanner scanUpToCharactersFromSet:projectNameCharacterSet intoString:&projectNameString];
    // Extracting hours
    NSString *hoursString;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"Hh:"] intoString:&hoursString];
    NSString *cleanedHoursString = hoursString;
    if (hoursString.length > 0) {
        cleanedHoursString = [[hoursString componentsSeparatedByCharactersInSet:
                               [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                              componentsJoinedByString:@""];
    }
    if (cleanedHoursString.length == 0) {
        cleanedHoursString = @"0";
    }
    // Extracting minutes
    NSString *minutesString;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"mM"] intoString:&minutesString];
    NSString *cleanedMinutesString = minutesString;
    if (minutesString.length > 0) {
        cleanedMinutesString = [[minutesString componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                componentsJoinedByString:@""];
    }
    if (cleanedMinutesString.length == 0) {
        cleanedMinutesString = @"0";
    }
    
    TimeEntry *entry = [TimeEntry new];
    entry.projectName = projectNameString;
    entry.billedTimeInterval = (cleanedHoursString.doubleValue <= 24.0f ? cleanedHoursString.doubleValue : 24.0f) * 60.0f * 60.0f + (cleanedMinutesString.doubleValue < 60.0f ? cleanedMinutesString.doubleValue : 60.0f) * 60.0f;
    return entry;
}

@end
