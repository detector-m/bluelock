//
//  NotifierMessageVC.m
//  Smartlock
//
//  Created by RivenL on 15/5/8.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "NotificationMessageVC.h"
#import "MessageContentVC.h"

#import "MyCoreDataManager.h"
#import "RLDate.h"

@interface NotificationMessageCell : ListCell

@end

@implementation NotificationMessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
    
    }
    
    return self;
}
@end


@implementation NotificationMessageVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"消息", nil);
    self.table.tableView.rowHeight = 66.0f;
    NSArray *messages = [[MyCoreDataManager sharedManager] objectsSortByAttribute:nil withTablename:NSStringFromClass([Message class])];
    [self.table addObjectFromArray:messages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageComming) name:@"MessageComming" object:nil];
}

#pragma mark -
- (void)messageComming {
    [self.table.datas removeAllObjects];
    NSArray *messages = [[MyCoreDataManager sharedManager] objectsSortByAttribute:nil withTablename:NSStringFromClass([Message class])];

    [self.table.datas addObjectsFromArray:messages];
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.table.tableView reloadData];
    });
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
    [tableView registerClass:[NotificationMessageCell class] forCellReuseIdentifier:kCellIdentifier];
    NotificationMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)kCellIdentifier forIndexPath:indexPath];
    NSInteger index = [self indexForData:indexPath];
    Message *message = [self.table.datas objectAtIndex:index];
    cell.textLabel.text = message.from;//[self.table.datas objectAtIndex:index];
    cell.imageView.image = [UIImage imageNamed:@"Phone.png"];
    cell.detailTextLabel.text = message.content;
    cell.timeLabel.text = timeStringWithTimestamp([message.timestamp longLongValue]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            MessageContentVC *vc = [[MessageContentVC alloc] init];
            NSInteger index = [self indexForData:indexPath];
            vc.message = [self.table.datas objectAtIndex:index];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        default:
            break;
    }
}

@end