//
//  Message.h
//  Smartlock
//
//  Created by RivenL on 15/5/15.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#pragma mark -
#import "XMPPManager.h"
#import "RLDate.h"

extern NSDictionary *messageDictionaryFromXMPPMessage(XMPPMessage *xmppMessage);

#pragma mark -

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * extension;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isRead;


@end
