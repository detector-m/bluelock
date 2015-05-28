//
//  MoreVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/12.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "MoreVC.h"

#import "MoreDetailVC.h"

@implementation MoreVC
{
    NSMutableArray *imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"更多", nil);
    
    self.table.tableView.rowHeight = 60.0f;
    self->imageArray = [NSMutableArray array];
    [self.table.datas addObject:@"关于"];
    [self.table.datas addObject:@"帮助"];
    [self.table.datas addObject:@"安装教程"];
    
    [self->imageArray addObject:@"About.png"];
    [self->imageArray addObject:@"Help.png"];
    [self->imageArray addObject:@"SetupNav.png"];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.table.datas.count;
}

- (NSInteger)indexForData:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    for(NSInteger i=0; i<indexPath.section; i++) {
        index += [self tableView:nil numberOfRowsInSection:i];
    }
    index += indexPath.row;
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[DefaultListCell class] forCellReuseIdentifier:kCellIdentifier];
    DefaultListCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)kCellIdentifier forIndexPath:indexPath];
    NSInteger index = [self indexForData:indexPath];
    cell.textLabel.text = [self.table.datas objectAtIndex:index];
    cell.imageView.image = [UIImage imageNamed:[self->imageArray objectAtIndex:index]];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreDetailVC *vc = [MoreDetailVC new];
    switch (indexPath.row) {
        case 0: {
            vc.url = @"http://www.dqcc.com.cn";
            vc.title = NSLocalizedString(@"关于", nil);
        }
            break;
        case 1: {
            vc.url = @"http://www.dqcc.com.cn";
            vc.title = NSLocalizedString(@"帮助", nil);
        }
            break;
        case 2: {
            vc.url = @"http://www.dqcc.com.cn";
            vc.title = NSLocalizedString(@"安装教程", nil);
        }
            break;
            
        default:
            return;
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
