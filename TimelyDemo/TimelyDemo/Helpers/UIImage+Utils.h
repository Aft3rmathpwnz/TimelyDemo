//
//  UIImage+Utils.h
//  TimelyDemo
//
//  Created by Boris Shulyak on 13/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

/**
 Fixes image orientation for capturing in portraint orientation. Temporary fix for demo.

 @return Transformed image that can be recognized further.
 */
- (UIImage *)fixedOrientation;

@end

NS_ASSUME_NONNULL_END
