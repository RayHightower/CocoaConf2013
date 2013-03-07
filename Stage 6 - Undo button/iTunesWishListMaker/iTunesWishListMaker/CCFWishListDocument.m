//
//  CCFWishListsDocument.m
//  iTunesShoppingListScratch2
//
//  Created by Chris Adamson on 3/4/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListDocument.h"

@implementation CCFWishListDocument

#pragma mark init/dealloc
-(id) initWithFileURL:(NSURL *)url {
	self = [super initWithFileURL:url];
	if (self) {
		_mutableWishListDicts = [[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}

#pragma mark defined methods
-(void) addItemDict:(NSDictionary *)dict {
	[self.mutableWishListDicts addObject:dict];
	[self.undoManager registerUndoWithTarget:self
									selector:@selector(removeItemDict:)
									  object:dict];
}

-(void) removeItemDict:(NSDictionary *)dict {
	[self.mutableWishListDicts removeObject:dict];
	[self.undoManager registerUndoWithTarget:self
									selector:@selector(addItemDict:)
									  object:dict];
}

#pragma mark uidocument persistence
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
	NSLog (@"contentsForType: %@", typeName);
    return [NSKeyedArchiver archivedDataWithRootObject:self.mutableWishListDicts];
}

- (BOOL)loadFromContents:(id)contents
                  ofType:(NSString *)typeName
                   error:(NSError *__autoreleasing *)outError {
    BOOL success = NO;
    if([contents isKindOfClass:[NSData class]] && [contents length] > 0) {
        NSData *data = (NSData *)contents;
        _mutableWishListDicts = [NSMutableArray arrayWithArray:
									[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        success = YES;
    }
    return success;
}


@end
