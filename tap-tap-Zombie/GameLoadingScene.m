//
//  LoadingLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 29.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "GameLoadingScene.h"
#import "GameScene.h"


@implementation GameLoadingScene

#pragma mark init and dealloc
- (id) initWithMap: (Map *) map_
{
    if(self = [super init])
    {
        map = [map_ retain];
        
        CCSprite *back = [CCSprite spriteWithFile: @"Default.png"];
        back.rotation = 90;
        back.position = kScreenCenter;
        [self addChild: back];
        
        CCLabelBMFont *loadingLabel = [CCLabelBMFont labelWithString: @"loading..." fntFile: kFontDefault];
        loadingLabel.position = kScreenCenter;
        [self addChild: loadingLabel];
    }
    
    return self;
}

+ (GameLoadingScene *) sceneWithMap: (Map *) map
{
    return [[[self alloc] initWithMap: map] autorelease];
}

- (void) dealloc
{
    [map release];
    
    [super dealloc];
}

#pragma mark -

- (void) onEnter
{
    [super onEnter];
    
    [self runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: 0.5f],
                                [CCCallFunc actionWithTarget: self selector: @selector(cleanMemoryAndLoadGameScene)],
                                nil
                ]
    ];
}

- (void) cleanMemoryAndLoadGameScene
{
    [[CCDirector sharedDirector] purgeCachedData];
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [[CCDirector sharedDirector] replaceScene:
                                        [CCTransitionFade transitionWithDuration: 0.3f 
                                                                           scene: [GameScene gameSceneWithMap: map] 
                                                                       withColor: ccc3(0, 0, 0)
                                        ]
    ];
}

@end
