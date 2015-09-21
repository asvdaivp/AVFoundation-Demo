//
//  CaptureSessionManager.h
//  SimpleAVFoundation
//
//  Created by phuocdai on 9/21/15.
//  Copyright (c) 2015 phuocdai. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface CaptureSessionManager : NSObject
@property(retain) AVCaptureSession *captureSession;
@property(retain) AVCaptureVideoPreviewLayer *previewLayer;
@property(retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, retain) UIImage *stillImage;

-(void)addVideoPreviewLayer;
-(void)addStillImageOutput;
-(void)captureStillImage;
-(void)addVideoInputFrontCamera: (BOOL)front;
@end
