//
//  CaptureSessionManager.m
//  SimpleAVFoundation
//
//  Created by phuocdai on 9/21/15.
//  Copyright (c) 2015 phuocdai. All rights reserved.
//
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@implementation CaptureSessionManager
@synthesize captureSession, previewLayer, stillImageOutput, stillImage;

- (id)init
{
    self = [super init];
    if (self) {
        [self setCaptureSession:[[AVCaptureSession alloc] init]];
    }
    return self;
}

-(void)addVideoPreviewLayer{
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
    [[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

-(void)addVideoInputFrontCamera:(BOOL)front{
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionFront) {
                frontCamera = device;
            } else {
                backCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    if (front){
        AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!error) {
            if ([[self captureSession] canAddInput:frontFacingCameraDeviceInput]) {
                [[self captureSession] addInput:frontFacingCameraDeviceInput];
            } else {
                NSLog(@"Couldn't add front facing video input");
            }
        }
        
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            if ([[self captureSession] canAddInput:backFacingCameraDeviceInput]) {
                [[self captureSession] addInput:backFacingCameraDeviceInput];
            } else {
                NSLog(@"Couldn't add back facing video input");
            }
        }
    }
}

-(void)addStillImageOutput{
    [self setStillImageOutput: [[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
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
    [[self captureSession] addOutput:[self stillImageOutput]];
}

-(void)captureStillImage{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection  = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments) {
            NSLog(@"attachements: %@", exifAttachments);
        } else {
            NSLog(@"no attachments");
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [self setStillImage:image];
        
    }];
    
}


- (void)dealloc {
    
    [[self captureSession] stopRunning];
    
}

@end
