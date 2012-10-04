//
//  MainMenuLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface MainMenuLayer : CCLayer <CCPopupLayerDelegate>
{
    CCMenuItem *playBtn;
    CCMenuItem *shopBtn;
}

+ (CCScene *) scene;

@end
