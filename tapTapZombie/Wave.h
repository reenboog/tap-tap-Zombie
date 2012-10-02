//
//  Wave.h
//  tapTapZombie
//
//  Created by Alexander on 12.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LogicGameItemDelegate;

@interface Wave : NSObject
{
    int index;
    int nItems;
    NSMutableDictionary *items;
    float firstTouchTime;
    int nMissingItems;
    
    int orderIndex;
}

@property (nonatomic, readonly) int index;
@property (nonatomic, readonly) int nMissingItems;

+ (id) wave;

- (void) addItem: (id<LogicGameItemDelegate>) item;
- (void) run;
- (int) count;
- (void) removeItem: (id<LogicGameItemDelegate>) item;

- (void) setOrderIndex: (int) i;

@end
