//
//  PhotoCaptureService.h
//  TimelyDemo
//
//  Created by Aft3rmath on 18/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

@import Foundation;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoCaptureServiceDelegate <NSObject>

/**
 Called when camera captured image after -startImageCapturing: call.

 @param image Captured UIImage.
 */
- (void)didCaptureImage:(UIImage *)image;

@end

@interface PhotoCaptureService : NSObject

@property (weak, nonatomic) id<PhotoCaptureServiceDelegate> delegate;
@property (assign, nonatomic, readonly) BOOL isPermissionGranted;

/**
 Starts camera capturing frames that are rendering on preview layer.

 @return Preview layer that displays current camera input.
 */
- (nullable AVCaptureVideoPreviewLayer *)startCamera;

/**
 Stops camera from capturing frames.
 */
- (void)stopCamera;

/**
 Captures image from camera frames asynchronously. Use -didCaptureImage: method of PhotoCaptureServiceDelegate to handle captured image.
 */
- (void)captureImage;

@end

NS_ASSUME_NONNULL_END
