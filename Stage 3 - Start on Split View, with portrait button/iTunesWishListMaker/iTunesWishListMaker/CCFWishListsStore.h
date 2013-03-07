//
//  CCFWishListsStore.h
//  iTunesWishListMaker
//
//  Created by RTH on 3/7/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFWishListDocument.h"

@interface CCFWishListsStore : NSObject
+(CCFWishListsStore*) sharedInstance;
@property (strong) CCFWishListDocument *currentWishList;
@property (readonly) NSMutableArray *localWishListURLs;
@property (readonly) NSMutableArray *iCloudWishListURLs;
-(void) createAndMakeCurrentWishList: (NSString*) name;

@end
