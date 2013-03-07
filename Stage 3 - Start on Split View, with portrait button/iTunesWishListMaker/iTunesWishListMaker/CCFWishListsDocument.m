//
//  CCFWishListsDocument.m
//  iTunesWishListMaker
//
//  Created by RTH on 3/7/13.
//  Copyright (c) 2013 Subsequently & Furthermore, Inc. All rights reserved.
//

#import "CCFWishListsDocument.h"

@implementation CCFWishListsDocument

- (id)initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self) {
        _mutableWishListDicts = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - add/remove
-(void) addItemDict:(NSDictionary *)dict {
    [self.mutableWishListDicts addObject:dict];

    // don't waste cycles on unnecessary saves
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
-(id) contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
    {
    return [NSKeyedArchiver archivedDataWithRootObject:self.mutableWishListDicts];
}

-(BOOL) loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    BOOL success = NO;
    if ([contents isKindOfClass:[NSData class]] &&
        [contents length] > 0) {
            NSData *data = (NSData*) contents;

        // What are the trade offs if we do self.mutableWishListsDicts?
            _mutableWishListDicts = [NSMutableArray arrayWithArray:
                                     [NSKeyedUnarchiver unarchiveObjectWithData:data]];
            success = YES;
        }
    
    
    
    return success;
}


@end
