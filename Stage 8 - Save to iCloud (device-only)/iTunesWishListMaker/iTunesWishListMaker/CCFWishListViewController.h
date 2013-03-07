//
//  CCFWishListViewController.h
//  iTunesShoppingListScratch2
//
//  Created by Chris Adamson on 3/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCFWishListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak) IBOutlet UITableView *tableView;
@end
