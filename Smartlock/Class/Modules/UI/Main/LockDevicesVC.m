//
//  LockDevicesVC.m
//  Smartlock
//
//  Created by RivenL on 15/3/23.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "LockDevicesVC.h"
#import "AddDeviceVC.h"
//#import "ScanningQRCodeVC.h"
#import "MainVC.h"

#import "LockModel.h"

@implementation LockDevicesVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"My Devices", nil);
 
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightItem)];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightItem)];
}

- (void)clickRightItem {
#if 0
    ScanningQRCodeVC *vc = [ScanningQRCodeVC new];
    vc.lockDevicesVC = self;
    [self.navigationController pushViewController:vc animated:YES];
#endif
    
    AddDeviceVC *vc = [AddDeviceVC new];
    vc.lockDevicesVC = self;
//    vc.manager = self.manager;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (void)addLockWithPeripheral:(LockModel *)lock {
    [self.mainVC addLock:lock];
    [self.table.datas addObject:lock];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.table.tableView reloadData];
    });
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.table.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[BaseCell class] forCellReuseIdentifier:kCellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)kCellIdentifier forIndexPath:indexPath];
//     cell.textLabel.text = @"lock";
    LockModel *lock = [self.table.datas objectAtIndex:indexPath.row];
    cell.textLabel.text = lock.name;
    cell.imageView.image = [UIImage imageNamed:@"LockIcon"];
    
    return cell;
 }


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [self.table.datas removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
