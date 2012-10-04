//
//  NotEnoughMoneyAlert.h
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface NotEnoughMoneyAlert : CCLayerColor
{
    CCLabelBMFont *label;
    
    BOOL isShown;
}

@property (nonatomic, readonly) BOOL isShown;

- (void) show;
- (void) hide;

@end
