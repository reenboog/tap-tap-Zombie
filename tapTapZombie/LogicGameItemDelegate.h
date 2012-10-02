//
//  GameItemDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 12.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum 
{
    gis_none,
    gis_moving,
    gis_standing,
    gis_disappearing
} GameItemState;

@protocol LogicGameItemDelegate <NSObject>

//- (int) wave;
//- (int) index;
//- (void) setWave: (int) wave;
//- (void) setIndex: (int) index;
@property (nonatomic) int wave;
@property (nonatomic) int index;

- (BOOL) isMissing;

- (void) reorder: (int) index;

@property(nonatomic,readwrite,assign) NSInteger tag;
@property (nonatomic, readonly) GameItemState state;
@property (nonatomic, readonly) float award;


@end
