//
//  CCFWishListNameChangeViewController.m
//  iTunesShoppingListScratch2
//
//  Created by Chris Adamson on 3/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListNameChangeViewController.h"
#import "CCFWishListsStore.h"
#import "CCFWishListDocument.h"

@interface CCFWishListNameChangeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation CCFWishListNameChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.nameField.text = self.fileName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
	[[CCFWishListsStore sharedInstance] renameCurrentWishList:textField.text];
	return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField	 {
	[textField resignFirstResponder];
	return YES;
}

@end
