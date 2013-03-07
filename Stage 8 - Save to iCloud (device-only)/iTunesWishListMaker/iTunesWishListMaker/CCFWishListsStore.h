//
//  CCFWishListsStore.h
//  iTunesShoppingListScratch2
//
//  Created by Chris Adamson on 3/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFWishListDocument.h"

@interface CCFWishListsStore : NSObject
+(CCFWishListsStore*) sharedInstance;
@property (strong) CCFWishListDocument *currentWishList;
@property (readonly) NSMutableArray *localWishListURLs;
@property (readonly) NSMutableArray *iCloudWishListURLs;
-(void) renameCurrentWishList: (NSString*) name;
-(void) createAndMakeCurrentWishList: (NSString*) name;
//-(void) importWishListFromURL: (NSURL*) url;
-(BOOL) saveWishListToICloud: (CCFWishListDocument*) wishList;
@end
