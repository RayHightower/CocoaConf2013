//
//  CCFWishListViewController.m
//  iTunesShoppingListScratch2
//
//  Created by Chris Adamson on 3/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListViewController.h"
#import "CCFWishListsStore.h"
#import "CCFWishListDocument.h"
#import "CCFWishListNameChangeViewController.h"
//#import "CCFWishListPDFExport.h"

@interface CCFWishListViewController ()
- (IBAction)handleUndoTapped:(id)sender;
- (IBAction)handleSaveToICloudTapped:(id)sender;
//- (IBAction)handleActionTapped:(id)sender;
//@property (strong) UIDocumentInteractionController *interactionController;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@end

@implementation CCFWishListViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//		[[NSNotificationCenter defaultCenter] addObserverForName:@"CurrentWishListChanged"
//														  object:nil
//														   queue:nil
//													  usingBlock:^(NSNotification *note)
//		 {
//			 [self.tableView reloadData];
//		 }];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder	
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
		[[NSNotificationCenter defaultCenter] addObserverForName:@"CurrentWishListChanged"
														  object:nil
														   queue:nil
													  usingBlock:^(NSNotification *note)
		 {
			 [self.tableView reloadData];
			 self.title = [[[CCFWishListsStore sharedInstance] currentWishList].fileURL lastPathComponent];
			 self.navigationController.navigationBar.topItem.title = [[[CCFWishListsStore sharedInstance] currentWishList].fileURL lastPathComponent];
		 }];
    }
    return self;
}


-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"CurrentWishListChanged"
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

-(void) viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[CCFWishListsStore sharedInstance].currentWishList.mutableWishListDicts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WishListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	NSDictionary *item = [[CCFWishListsStore sharedInstance].currentWishList.mutableWishListDicts
						  objectAtIndex:indexPath.row];
	NSString *title = [item objectForKey:@"collectionName"];
	if (!title) {
		title = [item objectForKey:@"trackName"];
	}
	if (!title) {
		title = [item objectForKey:@"trackCensoredName"];
	}
	cell.textLabel.text = title;
	
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSDictionary *item = [[CCFWishListsStore sharedInstance].currentWishList.mutableWishListDicts
							  objectAtIndex:indexPath.row];
		[[CCFWishListsStore sharedInstance].currentWishList removeItemDict:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
	// TODO: could show a detail page here or something
}

#pragma mark - event handlers

- (IBAction)handleUndoTapped:(id)sender {
	CCFWishListDocument *wishListDocument = [CCFWishListsStore sharedInstance].currentWishList;
	if ([wishListDocument.undoManager canUndo]) {
		[wishListDocument.undoManager undo];
		[self.tableView reloadData];
	} else {
		UIAlertView *cantUndoAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString (@"Can't undo", nil)
																message:NSLocalizedString (@"Nothing to undo", nil)
															   delegate:nil
													  cancelButtonTitle:NSLocalizedString(@"OK", nil)
													  otherButtonTitles: nil];
		[cantUndoAlert show];
	}
}

- (IBAction)handleSaveToICloudTapped:(id)sender {
	NSLog (@"saving to iCloud");
	BOOL saved = [[CCFWishListsStore sharedInstance] saveWishListToICloud:
				  [CCFWishListsStore sharedInstance].currentWishList];
	NSLog (@"save to iCloud returned %@", saved ? @"YES" : @"NO");
}
//
//- (IBAction)handleActionTapped:(id)sender {
//	CCFWishListPDFExport *exporter = [[CCFWishListPDFExport alloc] init];
//	NSURL *exportedURL = [exporter pathForExportedWishList];
//	NSLog (@"exported path to %@", exportedURL);
//	self.interactionController =
//	[UIDocumentInteractionController interactionControllerWithURL:exportedURL];
//	// print, mail, copy icons on iOS 6
//	[self.interactionController presentOptionsMenuFromBarButtonItem:self.actionButton
//														   animated:YES];
//	// none of the simulator apps can open a pdf, but this is cool on a real device
//	//	[self.interactionController presentOpenInMenuFromBarButtonItem:self.actionButton
//	//													 animated:YES];
//		
//}


#pragma mark - segues
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowNameChangePopover"]) {
		CCFWishListNameChangeViewController	*nameChangeVC = (CCFWishListNameChangeViewController*) segue.destinationViewController;
		nameChangeVC.fileName = [[[CCFWishListsStore sharedInstance] currentWishList].fileURL lastPathComponent];
	}
}

@end
