//
//  UIColor+Hex.h
//
//  Created by Aft3rmath on 09.05.17.
//  Copyright © 2017 aft3rmath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorwithHexString:(NSString *)hexStr;
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end

@interface UIColor (LightAndDark)

- (UIColor *)lighterColorByFactor:(CGFloat)factor;
- (UIColor *)darkerColorByFactor:(CGFloat)factor;

@end
