//
//  ScanningQRCodeVC.m
//  Smartlock
//
//  Created by RivenL on 15/3/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "ScanningQRCodeVC.h"
#import "SoundManager.h"
#import "LockDevicesVC.h"

@interface ScanningQRCodeVC ()
//-------------------------------------------------------------------------//
@property (nonatomic, strong) ZXCapture *capture;
//-------------------------------------------------------------------------//
@property (nonatomic, strong) UIView *scanRectView;

@property (nonatomic, strong) UILabel *label;
@end

@implementation ScanningQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    CGRect frame = self.scanRectView.frame;
    self.capture.scanRect = CGRectApplyAffineTransform(frame, captureSizeTransform);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"ScanningQRCode", nil);
    
    [self setupCapture];
    
    CGRect frame = self.view.frame;
    self.scanRectView = [UIView new];
    self.scanRectView.frame = CGRectMake(50, 100, frame.size.width-100 , frame.size.width-100);
    self.scanRectView.alpha = 0.2;
    self.scanRectView.backgroundColor = [UIColor lightGrayColor];
    self.scanRectView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.scanRectView.layer.borderWidth = 2.0;
    [self.view addSubview:self.scanRectView];
    
    self.label = [UILabel new];
    self.label.frame = CGRectMake(0, 10, frame.size.width, 90);
    self.label.numberOfLines = 0;
    [self.view addSubview:self.label];
}

- (void)setupCapture {
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
}
//-------------------------------------------------------------------------//
#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}
//-------------------------------------------------------------------------//

//-------------------------------------------------------------------------//
#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    if(!self.capture.running) {
        return;
    }
    [self.capture stop];
    
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!Format: %@ Contents:%@", formatString, result.text];
//    [self.label performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
    
    // Vibrate
    [[SoundManager sharedManager] playSound:@"ScanQRCode.mp3"];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    __weak ScanningQRCodeVC *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.capture stop];
        [weakSelf.lockDevicesVC.table.datas addObject:result.text];
        [weakSelf.lockDevicesVC.tableView reloadData];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}
//-------------------------------------------------------------------------//
@end
