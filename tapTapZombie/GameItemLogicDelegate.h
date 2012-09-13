//
//  GameItemDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 12.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LogicGameItemDelegate;

@protocol GameItemLogicDelegate <NSObject>

- (void) gameItemDisappears: (id<LogicGameItemDelegate>) item;

@end
