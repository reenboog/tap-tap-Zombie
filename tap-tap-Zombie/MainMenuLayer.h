//
//  MainMenuLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GlobalMapLayer.h"


@interface MainMenuLayer : CCLayer <CCPopupLayerDelegate, GlobalMapLayerDelegate>
{
//    CCMenuItem *playBtn;
    CCMenuItem *shopBtn;
    
    GlobalMapLayer *globalMap;
    
    CCSprite *evilDoctor;
}

+ (CCScene *) scene;

@end
