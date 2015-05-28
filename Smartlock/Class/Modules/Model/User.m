//
//  User.m
//  Smartlock
//
//  Created by RivenL on 15/4/9.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "User.h"

@interface User ()
@property (nonatomic, readwrite, assign) NSUInteger ID;
@property (nonatomic, readwrite, copy) NSString *name;
@end

@implementation User
@synthesize ID;
@synthesize name;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.dqID = [aDecoder decodeObjectForKey:@"dqID"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.gid = [aDecoder decodeObjectForKey:@"gid"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:self.dqID forKey:@"dqID"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.gid forKey:@"gid"];
}

#pragma mark -
- (void)setWithUser:(id)aUser {
    if(aUser == nil)
        return;
    __typeof(self)user = aUser;
    [super setWithUser:user];
    self.dqID = user.dqID;
    self.password = user.password;
    self.gid = user.gid;
}

- (void)setWithParameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0) {
        return;
    }
    
    parameters = [[parameters objectForKey:@"member"] firstObject];
    if(!parameters || parameters.count == 0) {
        return;
    }
    
    self.sessionToken = parameters[@"accessToken"];
    self.name = self.nickname = parameters[@"memberName"];
    self.phone = parameters[@"mobile"];
    self.dqID = parameters[@"guestChikyugo"];
    self.gid = parameters[@"gid"];
    self.gender = [parameters[@"sex"] integerValue];
}
@end
