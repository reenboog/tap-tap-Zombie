//
//  GameItemDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 12.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogicGameItemDelegate <NSObject>

//- (int) wave;
//- (int) index;
//- (void) setWave: (int) wave;
//- (void) setIndex: (int) index;
@property (nonatomic) int wave;
@property (nonatomic) int index;

- (BOOL) isMissing;

@end
