//
//  UIImage+Utils.m
//  TimelyDemo
//
//  Created by Boris Shulyak on 13/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

- (UIImage *)imageWithFixedOrientation {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, self.size.height);
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    
    CGContextRef ctx = CGBitmapContextCreate(nil, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextConcatCTM(ctx, transform);
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage *fixedImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(ctx);
    return fixedImage;
}

@end
