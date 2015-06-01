//
//  KeysOfLockVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/22.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "KeysOfLockVC.h"

#import "SubTitleListCell.h"

#import "DeviceManager.h"
#import "RLColor.h"

@implementation KeysOfLockVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"钥匙列表", nil);
}

- (void)setupRightItem {
}

- (void)setupLongPressGesture {

}

#pragma mark - 
- (void)loadKeysOfLockWithLockID:(NSUInteger)lockID {
    __weak __typeof(self)weakSelf = self;
    [DeviceManager keyListOfAdmin:lockID token:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.table.datas removeAllObjects];
            [weakSelf.table.datas addObjectsFromArray:response.list];
            [weakSelf.table.tableView reloadData];
        });
    }];
}

#pragma mark -
- (void)setLockId:(NSUInteger)lockId {
    _lockId = lockId;
    [self loadKeysOfLockWithLockID:lockId];
}

#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubTitleListCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)kCellIdentifier];
    if(!cell) {
        cell = [[SubTitleListCell alloc] initWithReuseIdentifier:kCellIdentifier aClass:[UIButton class]];
        UIButton *button = (UIButton *)cell.contentAccessoryView;
        [button addTarget:self action:@selector(clickCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [RLColor colorWithHex:0xFF7B00];//[UIColor blueColor];
    }
    KeyModel *key = [self.table.datas objectAtIndex:indexPath.row];
    cell.textLabel.text = key.name;
    if(key.type == kKeyTypeForever) {
        cell.detailTextLabel.text = @"永久";
    }
    else if(key.type == kKeyTypeTimes) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"还可使用%d次", key.validCount];
    }
    else  {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"钥匙有效期限%@", key.invalidDate];
    }
    cell.imageView.image = [UIImage imageNamed:@"KeyIcon"];

    UIButton *button = (UIButton *)cell.contentAccessoryView;
    button.tag = indexPath.row;
    if(!key.userType) {
        button.hidden = YES;
        return cell;
    }
    
    button.hidden = NO;
    button.tag = indexPath.row;
    if(!key.status) {
        [button setTitle:NSLocalizedString(@"冻结", nil) forState:UIControlStateNormal];
    }
    else {
        [button setTitle:NSLocalizedString(@"解冻", nil) forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)clickCellBtn:(UIButton *)button {
    button.enabled = NO;
//    __weak __typeof(self)weakSelf = self;
    KeyModel *key = [self.table.datas objectAtIndex:button.tag];
    [DeviceManager lockOrUnlockKey:key.ID operation:!key.status token:[User sharedUser].sessionToken withBlock:^(DeviceResponse *response, NSError *error) {
        if(error || response.status) {
            return ;
        }
        
        key.status = !key.status;
        dispatch_async(dispatch_get_main_queue(), ^{
            button.enabled = YES;
            
            if(!key.status) {
                [button setTitle:NSLocalizedString(@"冻结", nil) forState:UIControlStateNormal];
            }
            else {
                [button setTitle:NSLocalizedString(@"解冻", nil) forState:UIControlStateNormal];
            }
        });
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyModel *key = [self.table.datas objectAtIndex:indexPath.row];
    if(!key.userType) {
        
    }
}

@end
