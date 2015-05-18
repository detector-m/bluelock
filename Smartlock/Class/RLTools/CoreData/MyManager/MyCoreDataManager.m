//
//  MyCoreDataManager.m
//  Smartlock
//
//  Created by RivenL on 15/4/29.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MyCoreDataManager.h"
#import "RLCoreDataManagerSubclass.h"

@implementation MyCoreDataManager
+ (NSURL*)modelURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Smartlock" withExtension:RL_MODEL_EXTENSION_momd];
    
    if (modelURL == nil)    modelURL = [[NSBundle mainBundle] URLForResource:@"Smartlock" withExtension:RL_MODEL_EXTENSION_mom];
    
    return modelURL;
}

#pragma mark - RecordTable
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:NSStringFromClass([RecordTable class]) sortDescriptor:sortDescriptor];
}

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:NSStringFromClass([RecordTable class]) where:key contains:value sortDescriptor:sortDescriptor];
}

-(RecordTable*) insertRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTable*)[self insertRecordInTable:NSStringFromClass([RecordTable class]) withAttribute:recordAttribute];
}

- (RecordTable*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTable*)[self insertRecordInTable:NSStringFromClass([RecordTable class]) withAttribute:recordAttribute updateOnExistKey:kEmail equals:[recordAttribute objectForKey:kEmail]];
}

- (RecordTable*) updateRecord:(RecordTable*)record inRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTable*)[self updateRecord:record withAttribute:recordAttribute];
}

- (BOOL) deleteTableRecord:(RecordTable*)record
{
    return [self deleteRecord:record];
}

-(BOOL) deleteAllTableRecord
{
    return [self flushTable:NSStringFromClass([RecordTable class])];
}

#pragma mark -
- (NSArray *)objectsSortByAttribute:(NSString *)attribute withTablename:(NSString *)tablename {
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:tablename sortDescriptor:sortDescriptor];
}
- (NSArray *)objectsSortByAttribute:(NSString *)attribute where:(NSString *)key contains:(id)value withTabelname:(NSString *)tablename {
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:tablename where:key contains:value sortDescriptor:sortDescriptor];
}

- (id)insertObjectInObjectTable:(NSDictionary *)objectAttributes withTablename:(NSString *)tablename {
    return [self insertRecordInTable:tablename withAttribute:objectAttributes];
}

- (id)insertUpdateObjectInObjectTable:(NSDictionary *)objectAttributes withTablename:(NSString *)tablename {
    return [self insertRecordInTable:tablename withAttribute:objectAttributes updateOnExistKey:kEmail equals:[objectAttributes objectForKey:kEmail]];
}
- (id)updateObject:(id)object inObjectTable:(NSDictionary *)objectAttributes withTablename:(NSString *)tablename {
    return [self updateRecord:object withAttribute:objectAttributes];
}

- (BOOL)deleteTableRecord:(id)object withTablename:(NSString *)tablename {
    return [self deleteRecord:object];
}

- (BOOL)deleteAllTableObjectInTable:(NSString *)tablename {
    return [self flushTable:tablename];
}
@end
