//
//  GlobalMapLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "MapDifficultyPopupDelegate.h"


@interface GlobalMapLayer : CCLayer <MapDifficultyPopupDelegate>
{
    CCMenu *selectMapMenu;
    CCMenuItem *backBtn;
    
    int mapIndex;
}

+ (CCScene *) scene;

@end
