//
//  QTableViewController.m
//  QuickVFL
//
//  Created by sudi on 16/9/30.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QTableViewController.h"
#import "QDemoEntity.h"
#import "QTableViewCell.h"

@interface QTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView* tableViewContents;
@property (nonatomic, weak) QTableViewCell* sampleCell;
@property (nonatomic, strong) NSArray* arrayItems;
@end

@implementation QTableViewController

-(void)setupWidgets{
    
    self.title = @"Table View";
    
    _tableViewContents = QUICK_SUBVIEW(self.view, UITableView);
    
    // using sample cell to calculate will comsume double enegry
    // while refreshing the table view.
    // Do you know how to remove the unnecessary cost? There are tricks.
    // Try your best to do it.
    // This demo focus on VFL.
    _sampleCell = QUICK_SUBVIEW(self.view, QTableViewCell);
    _sampleCell.hidden = YES;
    
    NSString* layoutTree = @"H:|[_tableViewContents]|;V:|[_tableViewContents]|;\
    H:|[_sampleCell]|;V:|[_sampleCell];";
    [self.view q_addConstraintsByText:layoutTree
                        involvedViews:NSDictionaryOfVariableBindings(_tableViewContents, _sampleCell)];
    
    [self.view layoutIfNeeded];
    
    [self setupData];
    [self setupTableView];
}

-(void)setupTableView{
    self.tableViewContents.rowHeight = UITableViewAutomaticDimension;
    self.tableViewContents.estimatedRowHeight = 44;
    [self.tableViewContents registerClass:[QTableViewCell class] forCellReuseIdentifier:@"QCell"];
    self.tableViewContents.dataSource = self;
    self.tableViewContents.delegate = self;
    
    [self.tableViewContents reloadData];
}

-(void)setupData{
    NSArray* titlePool = @[
                           @"It has been said that everyone lives by selling something.",
                           @"The greatest bridge in the world.",
                           @"A very dear cat."
                           ];
    NSArray* descriptionPool = @[@"In the light of this statement, teachers live by selling knowledge, philosophers by selling wisdom and priests by selling spiritual comfort.",
                                 @"Though it may be possible to measure the value of material goods in terms of money, it is extremely difficult to estimate the true value of the services which people perform for us.", @"There are times when we would willingly give everything we possess to save our lives, yet we might grudge paying a surgeon a high fee for offering us precisely this service.",@"The conditions of society are such that skills have to be paid for in the same way that goods are paid for at a shop. ",
                                 @"Everyone has something to sell. ",
                                 @"Tramps seem to be the only exception to this general rule. ",
                                 @"Beggars almost sell themselves as human beings to arouse the pity of passers-by. ",
                                 @"But real tramps are not beggars. ",
                                 @"They have nothing to sell and require nothing from others. ",
                                 @"In seeking independence, they do not sacrifice their human dignity. ",
                                 @"A tramp may ask you for money, but he will never ask you to feel sorry for him. ",
                                 @"He has deliberately chosen to lead the life he leads and is fully aware of the consequences. ",
                                 @"He,may never be sure where the next meal is coming from, but he is free from the thousands of anxieties which afflict other people. ",
                                 @"His few material possession make it possible for him to move from place to place with ease- By having to sleep in the open, he gets far closer to the world of nature than most of us ever do. ",
                                 @"He may hunt, beg, or steal occasionally to keep himself alive; he may even in times of real need, do a little work; but he will never sacrifice his freedom We often speak of tramps with contempt and put them in the same class as beggars, but how many of us can honestly say that we have not felt a little envious of their simple way of life and their freedom from care?",];
    NSArray* notePool = @[
                          @"Available every night.", @"Available in Weekend", @"Inavailable"
                          ];
    
    NSArray* avatarPool = @[@"", @"angry", @"pirate", @"smile"];
    
    NSMutableArray* totalItems = [[NSMutableArray alloc] init];
    
    QDemoEntity* entity;
    for (int i=0; i< 1000; i++) {
        entity = [[QDemoEntity alloc] init];
        entity.title = titlePool[rand()%titlePool.count];
        entity.desc = descriptionPool[rand()%descriptionPool.count];
        entity.note = notePool[rand()%notePool.count];
        entity.avatar = [UIImage imageNamed:avatarPool[rand()%avatarPool.count]];
        entity.entityId = [NSString stringWithFormat:@"%d", i];
        
        [totalItems addObject:entity];
        
    }
    
    self.arrayItems = totalItems;
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QDemoEntity* entity = [self.arrayItems objectAtIndex:indexPath.row];
    
    [self.sampleCell fillWithTitle:entity.title
                       description:entity.desc
                              note:entity.note
                            avatar:entity.avatar];
    
    // flush the layout requests before calculating the height.
    [self.sampleCell layoutIfNeeded];
    return [self.sampleCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QCell"];
    QDemoEntity* entity = [self.arrayItems objectAtIndex:indexPath.row];
    [cell fillWithTitle:entity.title
                       description:entity.desc
                              note:entity.note
                            avatar:entity.avatar];
    
    [cell setNeedsLayout];
    return cell;
}
@end
