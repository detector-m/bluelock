//
//  RecordManager.m
//  Smartlock
//
//  Created by RivenL on 15/5/23.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RecordManager.h"

@implementation RecordManager
+ (void)updateRecordsWithBlock:(void (^)(BOOL success))block {
    NSArray *records = [[MyCoreDataManager sharedManager] objectsSortByAttribute:nil where:@"isUpdate" contains:@NO withTabelname:NSStringFromClass([OpenLockRecord class])];
    if(!records.count)
        return;
    NSString *recordsListString = @"";
    for(OpenLockRecord *record in records) {
        recordsListString = [recordsListString stringByAppendingString:record.toString];
        recordsListString = [recordsListString stringByAppendingString:@","];
    }
    recordsListString = [recordsListString stringByReplacingCharactersInRange:NSMakeRange(recordsListString.length-1, 1) withString:@""];
    
    [DeviceManager openLock:recordsListString token:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
        [[MyCoreDataManager sharedManager] updateObjectsInObjectTable:@{@"isUpdate":@YES} withKey:@"isUpdate" contains:@NO withTablename:NSStringFromClass([OpenLockRecord class])];
        if(block) {
            block(YES);
        }
    }];
}

@end
