//
//  LoadingLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 29.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Map.h"

@interface GameLoadingScene : CCScene
{
    Map *map;
}

+ (GameLoadingScene *) sceneWithMap: (Map *) map;
- (id) initWithMap:(Map *) map;

@end
