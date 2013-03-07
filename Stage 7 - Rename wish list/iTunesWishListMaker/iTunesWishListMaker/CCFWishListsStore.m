//
//  CCFWishListsStore.m
//  iTunesShoppingListScratch2
//
//  Created by Chris Adamson on 3/5/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListsStore.h"
#import "CCFWishListDocument.h"

CCFWishListsStore *CCFWishListsStoreSharedInstance;

@interface CCFWishListsStore()
@end

@implementation CCFWishListsStore

@synthesize currentWishList = _currentWishList;

#pragma mark init/dealloc & shared instance
- (id)init
{
    self = [super init];
    if (self) {
        _localWishListURLs = [[NSMutableArray alloc] init];
		_iCloudWishListURLs = [[NSMutableArray alloc] init];
		[self loadLocalWishLists];
//		[self loadICloudWishLists];
    }
    return self;
}

+(CCFWishListsStore*) sharedInstance {
	if (!CCFWishListsStoreSharedInstance) {
		CCFWishListsStoreSharedInstance = [[CCFWishListsStore alloc] init];
	}
	return CCFWishListsStoreSharedInstance;
}


#pragma mark local files
-(NSURL*) localDocumentsDirectory {
	NSArray *directories = [[NSFileManager defaultManager]
							URLsForDirectory:NSDocumentDirectory
							inDomains:NSUserDomainMask];
	return [directories objectAtIndex:0];
}

-(NSURL*) localWishListsDirectory {
	return [[self localDocumentsDirectory] URLByAppendingPathComponent:@"wishlists"];
}

-(void) loadLocalWishLists {
	[self.localWishListURLs removeAllObjects];
	NSString *wishListsPath = [[self localWishListsDirectory] path];
	BOOL isDirectory = NO;
	BOOL pathExists = [[NSFileManager defaultManager] fileExistsAtPath:wishListsPath
														   isDirectory:&isDirectory];
	if (!pathExists) {
		// create the directory and seed an empty document
		NSError *createDirectoryErr = nil;
		[[NSFileManager defaultManager] createDirectoryAtPath:wishListsPath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:&createDirectoryErr];
		NSString *defaultDocPath = [wishListsPath stringByAppendingPathComponent:@"Untitled.wishlist"];
		NSURL *defaultDocURL = [NSURL fileURLWithPath:defaultDocPath];
		CCFWishListDocument *emptyWishList = [[CCFWishListDocument alloc] initWithFileURL:defaultDocURL];
		[emptyWishList saveToURL:defaultDocURL
				forSaveOperation:UIDocumentSaveForCreating
			   completionHandler:^(BOOL success) {
				   NSLog (@"saved %@: %@", defaultDocURL, success ? @"YES" : @"NO");
				   if (success) {
					   [self loadLocalWishLists];
				   }
			   }
		 ];
		return; // reload after the empty document is saved
	}
	
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[self localWishListsDirectory]
													  includingPropertiesForKeys:nil
																		 options:0
																		   error:nil];
	for (NSURL *wishListURL in contents) {
		if ([[wishListURL pathExtension] isEqualToString: @"wishlist"]) {
			NSLog (@"found %@", wishListURL);
			[self.localWishListURLs addObject:wishListURL];
			if (! self.currentWishList) {
				CCFWishListDocument *defaultWishList = [[CCFWishListDocument alloc] initWithFileURL:wishListURL];
				[defaultWishList openWithCompletionHandler:^(BOOL success) {
					self.currentWishList = defaultWishList;
					NSLog (@"opened default wishlist at %@", wishListURL);
				}];
			}
		}
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LocalWishListsChanged"
														object:self];
}

#pragma mark iCloud
//-(NSURL*) iCloudDocumentsDirectory {
//	NSURL *cloudURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
//	cloudURL = [cloudURL
//				URLByAppendingPathComponent:@"Documents"
//				isDirectory:YES];
//	return cloudURL;
//}
//
//-(NSURL*) iCloudWishListsDirectory {
//	return [[self iCloudDocumentsDirectory] URLByAppendingPathComponent:@"wishlists"];
//}
//
//-(void) loadICloudWishLists {
//	[self.iCloudWishListURLs removeAllObjects];
//	// note addition: if we don't have iCloud permission, need to abort rather than crash on next line
//	if (! [self iCloudDocumentsDirectory]) {
//		return;
//	}
//	NSString *wishListsPath = [[self iCloudWishListsDirectory] path];
//	NSLog (@"iCloud WishLists path: %@", wishListsPath);
//	BOOL isDirectory = NO;
//	BOOL pathExists = [[NSFileManager defaultManager] fileExistsAtPath:wishListsPath
//														   isDirectory:&isDirectory];
//	NSLog (@"pathExists = %@", pathExists? @"YES" : @"NO");
//	if (!pathExists) {
//		// create the directory
//		NSError *createDirectoryErr = nil;
//		[[NSFileManager defaultManager] createDirectoryAtPath:wishListsPath
//								  withIntermediateDirectories:YES
//												   attributes:nil
//														error:&createDirectoryErr];
//		NSLog (@"created iCloud wishlists directory, error is %@", createDirectoryErr);
//	}
//	
//	
//	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[self iCloudWishListsDirectory]
//													  includingPropertiesForKeys:nil
//																		 options:0
//																		   error:nil];
//	for (NSURL *wishListURL in contents) {
//		if ([[wishListURL pathExtension] isEqualToString: @"wishlist"]) {
//			NSLog (@"found iCloud doc %@", wishListURL);
//			[self.iCloudWishListURLs addObject:wishListURL];
//		}
//	}
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"iCloudWishListsChanged"
//														object:self];
//}
//
//-(BOOL) saveWishListToICloud: (CCFWishListDocument*) wishList {
//	if (! [self iCloudDocumentsDirectory]) {
//		return NO;
//	}
//	NSString *fileName = [wishList.fileURL lastPathComponent];
//	NSURL *iCloudURL = [[self iCloudWishListsDirectory] URLByAppendingPathComponent:fileName];
//	CCFWishListDocument *iCloudList = [[CCFWishListDocument alloc] initWithFileURL:iCloudURL];
//	iCloudList.mutableWishListDicts = wishList.mutableWishListDicts;
//	NSLog (@"saving %d items to iCloud URL: %@", [iCloudList.mutableWishListDicts count], iCloudURL);
//	[iCloudList saveToURL:iCloudURL
//		 forSaveOperation:UIDocumentSaveForCreating
//		completionHandler:^(BOOL success) {
//			if (success) {
//				NSLog (@"*** saved to iCloud");
//				[[NSNotificationCenter defaultCenter] postNotificationName:@"iCloudWishListsChanged"
//																	object:self];
//			} else {
//				NSLog (@"*** iCloud save failed");
//			}
//		}];
//	return YES;
//}

#pragma mark override
-(void) setCurrentWishList:(CCFWishListDocument *)currentWishList {
	if (_currentWishList != currentWishList) {
		// save off the old one
		if (_currentWishList) {
			[_currentWishList closeWithCompletionHandler:^(BOOL success) {
				NSLog (@"closed wishlist at %@", _currentWishList.fileURL);
			}];
		}
		_currentWishList = currentWishList;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentWishListChanged"
															object:self];
	}
}

-(CCFWishListDocument*) currentWishList {
	return _currentWishList;
}

#pragma mark edit/new
-(void) renameCurrentWishList: (NSString*) name {
	NSURL *parentURL = [self.currentWishList.fileURL URLByDeletingLastPathComponent];
	NSURL *changedURL = [parentURL URLByAppendingPathComponent:name];
	[self.currentWishList saveToURL:changedURL
				   forSaveOperation:UIDocumentSaveForCreating
				  completionHandler:^(BOOL success)
	 {
		 [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentWishListChanged"
															 object:self];
		 [self loadLocalWishLists];
	 }];
	
}

#pragma mark icloud
-(NSURL*) iCloudDocumentsDirectory {
    NSURL *cloudURL = [[NSFileManager defaultManager]
                       URLForUbiquityContainerIdentifier:nil];
    cloudURL = [cloudURL URLByAppendingPathComponent:@"Documents"];
    return cloudURL;
    
}

-(NSURL*) iCloudwishListDirectory {
    return [[self iCloudDocumentsDirectory]
            URLByAppendingPathComponent:@"wishklists"];
}

-(void) loadiCloudWishLists {
    [self.iCloudWishListURLs removeAllObjects];
    //bail if no iCloud
    if (! [self iCloudDocumentsDirectory]) {
        // More here................................................
        
        
        
    }
}



#pragma mark defined methods

-(void) createAndMakeCurrentWishList:(NSString *)name {
	NSURL *parentURL = [self.currentWishList.fileURL URLByDeletingLastPathComponent];
	NSURL *createdURL = [parentURL URLByAppendingPathComponent:name];
	CCFWishListDocument *emptyWishList = [[CCFWishListDocument alloc] initWithFileURL:createdURL];
	[emptyWishList saveToURL:createdURL
			forSaveOperation:UIDocumentSaveForCreating
		   completionHandler:^(BOOL success) {
			   NSLog (@"saved %@: %@", createdURL, success ? @"YES" : @"NO");
			   if (success) {
				   self.currentWishList = emptyWishList;
				   [self loadLocalWishLists];
			   }
		   }
	 ];
}

//-(void) importWishListFromURL: (NSURL*) url {
//	CCFWishListDocument *importedWishList = [[CCFWishListDocument alloc] initWithFileURL:url];
//	[importedWishList openWithCompletionHandler:^(BOOL success) {
//		if (success) {
//			// save it back to the documents directory
//			NSString *fileName = [url lastPathComponent];
//			NSURL *localURL = [[self localWishListsDirectory] URLByAppendingPathComponent:fileName];
//			[importedWishList saveToURL:localURL
//					   forSaveOperation:UIDocumentSaveForCreating
//					  completionHandler:^(BOOL success) {
//						  self.currentWishList = importedWishList;
//						  [self loadLocalWishLists];
//					  }];
//		}
//	}];
//}

@end
