//
//  CCFWishListsStore.h
//  iTunesWishListMaker
//
//  Created by RTH on 3/7/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFWishListsDocument.h"

@interface CCFWishListsStore : NSObject
+(CCFWishListsStore*) sharedInstance;
@property (strong) CCFWishListsDocument *currentWishList;
@property (readonly) NSMutableArray *localWishListURLs;
@property (readonly) NSMutableArray *iCloudWishListURLs;
-(void) createAndMakeCurrentWishList: (NSString*) name;

@end
