//
//  CCFWishListsDocument.h
//  iTunesWishListMaker
//
//  Created by RTH on 3/7/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCFWishListDocument : UIDocument
@property (copy) NSMutableArray *mutableWishListDicts;
-(void) addItemDict: (NSDictionary*) dict;
-(void) removeItemDict: (NSDictionary*) dict;

@end
