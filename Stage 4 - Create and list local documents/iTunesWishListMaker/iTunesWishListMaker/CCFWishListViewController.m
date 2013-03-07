//
//  CCFWishListViewController.m
//  iTunesWishListMaker
//
//  Created by RTH on 3/7/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListViewController.h"
#import "CCFAllWishListsViewController.h"
#import "CCFStoreItemDetailViewController.h"
#import "CCFWishListsStore.h"

@interface CCFWishListViewController ()

@end

@implementation CCFWishListViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter]
         addObserverForName:@"CurrentWishListChanged"
         object:nil
         queue:nil
         usingBlock:^(NSNotification *note) {
             [self.tableView reloadData]
        }];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[CCFWishListsStore sharedInstance].currentWishList.mutableWishListDicts count];
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WishListCell"];
    
    NSDictionary *item = [CCFWishListsStore sharedInstance].currentWishList.mutableWishListDicts[indexPath.row];
    NSString *title = item[@"collectionName"];
    if (!title) {
        title = item[@"trackName"];
    }
    if (!title) {
        title = item[@"trackCensoredName"];
    }
    cell.textLabel.text = title;
    return cell;
}

@end
