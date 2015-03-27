//
//  ScanningQRCodeVC.h
//  Smartlock
//
//  Created by RivenL on 15/3/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "BaseVC.h"

#import "ZXingObjC.h"

@class LockDevicesVC;
@interface ScanningQRCodeVC : BaseVC <ZXCaptureDelegate>
@property (nonatomic, weak) LockDevicesVC *lockDevicesVC;
@end
