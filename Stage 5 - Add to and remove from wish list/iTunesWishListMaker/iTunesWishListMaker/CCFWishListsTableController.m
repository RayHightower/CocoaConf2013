//
//  CCFWishListsTableController.m
//  iTunesShoppingListScratch2
//
//  Created by Chris Adamson on 3/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListsTableController.h"
#import "CCFWishListsStore.h"
//#import "CCFWishListViewController.h"

@interface CCFWishListsTableController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *directorySegmentedControl;
- (IBAction)directorySegmentedControlValueChanged:(id)sender;
- (IBAction)handleAddTapped:(id)sender;

@end

@implementation CCFWishListsTableController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:@"LocalWishListsChanged"
														  object:nil
														   queue:nil
													  usingBlock:^(NSNotification *note)
		 {
			 [self.tableView reloadData];
		 }];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"iCloudWishListsChanged"
														  object:nil
														   queue:nil
													  usingBlock:^(NSNotification *note)
		 {
			 [self.tableView reloadData];
		 }];
    }
    return self;
}

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"LocalWishListsChanged"
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"iCloudWishListsChanged"
												  object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSMutableArray*) relevantWishListsArray {
	if ([self.directorySegmentedControl selectedSegmentIndex] == 0) {
		return [CCFWishListsStore sharedInstance].localWishListURLs;
	} else {
		return [CCFWishListsStore sharedInstance].iCloudWishListURLs;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	return [[self relevantWishListsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WishListNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSURL *wishListURL = [[self relevantWishListsArray] objectAtIndex:indexPath.row];
	cell.textLabel.text = [wishListURL lastPathComponent];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// reset the current document
	NSURL *wishListURL = [[self relevantWishListsArray] objectAtIndex:indexPath.row];
	CCFWishListDocument *openedDocument = [[CCFWishListDocument alloc] initWithFileURL:wishListURL];
	[openedDocument openWithCompletionHandler:^(BOOL success) {
		if (success) {
			NSLog (@"openedDocument dicts:%@", openedDocument.mutableWishListDicts);
			[CCFWishListsStore sharedInstance].currentWishList = openedDocument;
		}
	}];

	
}

#pragma mark actions

- (IBAction)directorySegmentedControlValueChanged:(id)sender {
	[self.tableView reloadData];
}

- (IBAction)handleAddTapped:(id)sender {
	NSString *defaultName = [NSString stringWithFormat:@"Untitled %@.wishlist", [NSDate date]];
	[[CCFWishListsStore sharedInstance] createAndMakeCurrentWishList:defaultName];
	[self.tableView reloadData];
}
@end
