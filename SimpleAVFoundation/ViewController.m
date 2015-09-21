//
//  ViewController.m
//  SimpleAVFoundation
//
//  Created by phuocdai on 9/21/15.
//  Copyright (c) 2015 phuocdai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)didTouchCapture:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@end

@implementation ViewController
@synthesize captureManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    [self setCaptureManager:[[CaptureSessionManager alloc] init]];
    [captureManager addVideoInputFrontCamera:NO];
    [captureManager addStillImageOutput];
    [captureManager addVideoPreviewLayer];
    CGRect layerRect = [self.view.layer bounds];
    [[captureManager previewLayer]setBounds:layerRect];
    [[captureManager previewLayer]setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    [self.view.layer addSublayer:[captureManager previewLayer]];
    [self.view addSubview:self.captureButton];
    [[captureManager captureSession] startRunning];
}

- (IBAction)didTouchCapture:(id)sender {
    [[self captureManager] captureStillImage];
}
@end
