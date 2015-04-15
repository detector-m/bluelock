//
//  DeviceManager.m
//  Smartlock
//
//  Created by RivenL on 15/4/14.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager
+ (void)addBluLock:(LockModel *)lock withBlock:(void (^)(DeviceResponse *, NSError *))block {

    void (^callBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        DeviceResponse *response = [[DeviceResponse alloc] initWithResponseObject:responseObject];
        
        if(block) {
            block(response, nil);
        }
    };
    
    [DeviceRequest addBluLock:lock withBlock:callBlock];
}

+ (void)sendKey:(KeyModel *)key withBlock:(void (^)(DeviceResponse *, NSError *))block {
    void (^callBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        DeviceResponse *response = [[DeviceResponse alloc] initWithResponseObject:responseObject];
        
        if(block) {
            block(response, nil);
        }
    };
    
    [DeviceRequest sendKey:key withBlock:callBlock];
}

+ (void)lockList:(NSString *)accessToken withBlock:(void (^)(DeviceResponse *, NSError *))block {
    void (^callBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        DeviceResponse *response = [[DeviceResponse alloc] initWithResponseObject:responseObject];
        
        if(block) {
            block(response, nil);
        }
    };
    [DeviceRequest lockList:accessToken withBlock:callBlock];
}

+ (void)keyListOfAdmin:(NSUInteger)lockID token:(NSString *)token withBlock:(void (^)(DeviceResponse *, NSError *))block {
    void (^callBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        DeviceResponse *response = [[DeviceResponse alloc] initWithResponseObject:responseObject];
        
        if(block) {
            block(response, nil);
        }
    };
    [DeviceRequest keyListOfAdmin:lockID token:token withBlock:callBlock];
}

+ (void)lockOrUnlockKey:(NSUInteger)lockID keyID:(NSUInteger)keyID operation:(NSUInteger)operation token:(NSString *)token withBlock:(void (^)(DeviceResponse *, NSError *))block {
    void (^callBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        DeviceResponse *response = [[DeviceResponse alloc] initWithResponseObject:responseObject];
        
        if(block) {
            block(response, nil);
        }
    };
    
    [DeviceRequest lockOrUnlockKey:lockID keyID:keyID operation:operation token:token withBlock:callBlock];
}

+ (void)openLock:(NSUInteger)lockID keyID:(NSUInteger)keyID token:(NSString *)token withBlock:(void (^)(DeviceResponse *, NSError *))block {
    void (^callBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if(error) {
            if(block) {
                block(nil, error);
            }
            return ;
        }
        DeviceResponse *response = [[DeviceResponse alloc] initWithResponseObject:responseObject];
        
        if(block) {
            block(response, nil);
        }
    };
    [DeviceRequest openLock:lockID keyID:keyID token:token withBlock:callBlock];
}
@end
