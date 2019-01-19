//
//  PhotoCaptureService.m
//  TimelyDemo
//
//  Created by Aft3rmath on 18/01/2019.
//  Copyright © 2019 Boris Shulyak. All rights reserved.
//

#import "PhotoCaptureService.h"
// Frameworks
@import UIKit;
@import AVFoundation;


NS_ASSUME_NONNULL_BEGIN

@interface PhotoCaptureService () <AVCapturePhotoCaptureDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (strong, nonatomic, nullable) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (assign, nonatomic) BOOL havePermission;

/**
 Configures and starts session with default device input, creates preview layer.
 */
- (void)initializeCamera;

/**
 Checks camera permission.
 */
- (void)checkPermission;

@end

NS_ASSUME_NONNULL_END

@implementation PhotoCaptureService
@dynamic isPermissionGranted;

#pragma mark - Properties

- (BOOL)isPermissionGranted {
    return _havePermission;
}

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        [self checkPermission];
    }
    return self;
}

#pragma mark - Public

- (AVCaptureVideoPreviewLayer *)startCamera {
    if (TARGET_IPHONE_SIMULATOR) {
        return nil;
    }
    if (!_session) {
        [self initializeCamera];
    }
    [_session startRunning];
    return _previewLayer;
}

- (void)stopCamera {
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    [_session stopRunning];
}

- (void)captureImage {
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    [_stillImageOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
}

#pragma mark - Private

- (void)checkPermission {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
            case AVAuthorizationStatusAuthorized:
            _havePermission = YES;
            break;
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    self.havePermission = YES;
                }];
                break;
            }
        default:
            break;
    }
}

- (void)initializeCamera {
    self.session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    self.captureDevice = inputDevice;
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice
                                                                              error:&error];
    if ([_session canAddInput:deviceInput]) {
        [_session addInput:deviceInput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.backgroundColor = UIColor.clearColor.CGColor;
    
    AVCapturePhotoOutput *stillImageOutput = [[AVCapturePhotoOutput alloc] init];
    if([_session canAddOutput:stillImageOutput]) {
        [_session addOutput:stillImageOutput];
        self.stillImageOutput = stillImageOutput;
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    UIImage *capturedImage = [[UIImage alloc] initWithCGImage:photo.CGImageRepresentation];
    if ([_delegate respondsToSelector:@selector(didCaptureImage:)]) {
        [_delegate didCaptureImage: capturedImage];
    }
}

@end
