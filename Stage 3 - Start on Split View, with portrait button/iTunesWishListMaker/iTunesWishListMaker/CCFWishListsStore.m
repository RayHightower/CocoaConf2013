//
//  CCFWishListsStore.m
//  iTunesWishListMaker
//
//  Created by RTH on 3/7/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListsStore.h"
#import "CCFWishListDocument.h"

// Global C varaible? Oh no!!!
CCFWishListsStore *CCFWishListsStoredSharedInstance;

@implementation CCFWishListsStore

@synthesize currentWishList = _currentWishList;

+(CCFWishListsStore*) sharedInstance {
    if (!CCFWishListsStoredSharedInstance) {
        CCFWishListsStoredSharedInstance = [[CCFWishListsStore alloc] init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _localWishListURLs = [[NSMutableArray alloc] init];
        _iCloudWishListURLs = [[NSMutableArray alloc] init];
        
        // TODO: Add methods to load the wishLists
        [self loadLocalWishLists];
        
    }
    return self;
}

#pragma mark property override
-(void) setCurrentWishList:(CCFWishListDocument *)currentWishList {
    if (_currentWishList != currentWishList) {
        if (_currentWishList) {
            [_currentWishList closeWithCompletionHandler:^(BOOL success) {
                NSLog (@"closed wish list at %@", _currentWishList.fileURL);
                
            }];
        }
        _currentWishList = currentWishList;         // the instance variable gets set to the parameter being passed in
        [[NSNotificationCenter defaultCenter]
         postNotificationName: @"CurrentWishListChanged"
         object:self];
        
    }
}

-(CCFWishListDocument*) currentWishList {
    return _currentWishList;
}

#pragma mark local files
-(NSURL*) localDocumentsDirectory {
    NSArray *directories = [[NSFileManager defaultManager]
                            URLsForDirectory:NSDocumentDirectory
                            inDomains:NSUserDomainMask];

    // return [directories objectAtIndex:0];  // old array syntax
    return directories[0];  //using the new array syntax
}

-(NSURL*) localWishListsDirectory {
    return [[self localDocumentsDirectory]
            URLByAppendingPathComponent:@"wishLists"];
}

-(void) loadLocalWishLists {
    [self.localWishListURLs removeAllObjects];
    NSString *wishListsPath = [[self localWishListsDirectory] path];
    BOOL pathExists = [[NSFileManager defaultManager]
                       fileExistsAtPath:wishListsPath];
    
    if (!pathExists) {
        // create directory and seed the empty document
        NSError *createDirectoryErr = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:wishListsPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&createDirectoryErr];
        NSURL *defaultDocURL = [[self localWishListsDirectory]
                                URLByAppendingPathComponent:@"Untitled.wishlist"];
        CCFWishListDocument *emptyWishList = [[CCFWishListDocument alloc]
                                              initWithFileURL:defaultDocURL];
        [emptyWishList saveToURL:defaultDocURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   NSLog (@"created %@", defaultDocURL);
                   [self loadLocalWishLists];
               }];
        return;
    }
    
    // load the .wishlists URLs
    NSArray *contents = [[NSFileManager defaultManager]
                         contentsOfDirectoryAtURL:[self localWishListsDirectory]
                         includingPropertiesForKeys:nil
                         options:0
                         error:nil];

    for (NSURL *wishListURL in contents) {
        if ([[wishListURL pathExtension] isEqualToString:@"wishlist"]) {
            [self.localWishListURLs addObject:wishListURL];
            if (!self.currentWishList) {
                CCFWishListDocument *defaultWishList = [[CCFWishListDocument alloc] initWithFileURL:wishListURL];
                
                [defaultWishList openWithCompletionHandler:^(BOOL success) {
                    self.currentWishList = defaultWishList;
                    NSLog(@"opened default wishlist at %@", wishListURL);
                }];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LocalWishListsChanged"
     object:self];
    
}



@end








