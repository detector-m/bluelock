//
//  RLCoreDataManager.h
//  Smartlock
//
//  Created by RivenL on 15/4/28.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <CoreData/CoreData.h>

@interface RLCoreDataManager : NSObject
+ (instancetype)sharedManager;

- (BOOL)save;
@end
