//
//  MainMenuLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "MainMenuLayer.h"
#import "ShopPopup.h"

#import "GlobalMapLayer.h"

#import "WaveCache.h"

#import "AnimationLoader.h"



@interface MainMenuLayer()
- (void) runStartAnimation;
@end


@implementation MainMenuLayer

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    MainMenuLayer *mainMenuLayer = [MainMenuLayer node];
    
    [scene addChild: mainMenuLayer];
    
    return scene;
}

+ (void) initialize
{
    [[CCTextureCache sharedTextureCache] addImage: @"mainMenu/evilDoctor.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"mainMenu/evilDoctor.plist"];
    
    [AnimationLoader loadAnimationsWithPlist: @"mainMenu/animations"];
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        [[CCDirector sharedDirector] purgeCachedData];
    
        globalMap = [GlobalMapLayer globalMapLayerWithDelegate: self];
        [self addChild: globalMap z: -1];
        [globalMap disableWithChildren];
        
        // main menu
        CCMenu *menu;
        CCSprite *btnSprite;
        CCSprite *btnOnSprite;
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/shopBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/shopBtnOn.png"];
        shopBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnOnSprite
                                                  target: self
                                                selector: @selector(shopBtnCallback)];
        shopBtn.anchorPoint = ccp(1, 0);
        shopBtn.scale = 0.7f;
        
        shopBtn.visible = NO;
        shopBtn.isEnabled = NO;
        
        menu = [CCMenu menuWithItems: shopBtn, nil];
        [menu alignItemsHorizontally];
        menu.position = ccp(kScreenWidth - 8.0f, 8.0f);
        [self addChild: menu];
        
        // evil doctor
        evilDoctor = [CCSprite node];
        evilDoctor.anchorPoint = ccp(0, 0);
        evilDoctor.position = ccp(-kScreenCenterX, 0);
        [self addChild: evilDoctor];
        [evilDoctor runAction: 
                    [CCAnimate actionWithAnimation: [[CCAnimationCache sharedAnimationCache] animationByName: @"evilDoctorStand"]
                               restoreOriginalFrame: NO
                    ]
        ];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (void) onEnter
{
    [super onEnter];
    
    [self runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: 0.5f],
                                [CCCallFunc actionWithTarget: globalMap selector: @selector(showMapPoints)],
                                [CCCallFunc actionWithTarget: self selector: @selector(runStartAnimation)],
                                nil
                ]
    ];
}

#pragma mark -

#pragma mark CCPopupLayerDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [self disableWithChildren];
    
    CCAnimationCache *ac = [CCAnimationCache sharedAnimationCache];
    CCFiniteTimeAction *animation = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorStand"]
                                              restoreOriginalFrame: NO];
    
    [evilDoctor stopAllActions];
    [evilDoctor runAction:
                    [CCSequence actions:
                                    [CCEaseBackIn actionWithAction:
                                                    [CCMoveTo actionWithDuration: 0.3f 
                                                                        position: ccp(-kScreenCenterX, 0)
                                                    ]
                                    ],
                                    animation,
                                    nil
                    ]
    ];
}

- (void) popupDidFinishClosing: (CCPopupLayer *) popup
{
    [self enableWithChildren];
    
    [evilDoctor stopAllActions];
    [evilDoctor runAction:
                    [CCSequence actions:
                                    [CCEaseBackOut actionWithAction:
                                                    [CCMoveTo actionWithDuration: 0.3f 
                                                                        position: ccp(-24.0f, 0)
                                                    ]
                                    ],
                                    [CCCallFunc actionWithTarget: self selector: @selector(runRandomAnimation)],
                                    nil
                    ]
    ];
}

#pragma mark -

#pragma mark callbacks
- (void) shopBtnCallback
{
    [ShopPopup showOnRunningSceneWithDelegate: self];
}

#pragma mark -

#pragma mark evil doctor
- (void) runRandomAnimation
{
    CCAnimationCache *ac = [CCAnimationCache sharedAnimationCache];
    CCFiniteTimeAction *animation = nil;
    
    int dice = arc4random()%3;
    
    switch(dice)
    {
        case 0:
        {
            animation = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorEyes"]
                                  restoreOriginalFrame: NO];
        } break;
            
        case 1:
        {
            animation = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorLaugh"]
                                  restoreOriginalFrame: NO];
        } break;
            
        default:
        {
            animation = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorSwitch"]
                                  restoreOriginalFrame: NO];
            
            [self runAction:
                        [CCSequence actions:
                                        [CCDelayTime actionWithDuration: 0.56f],
                                        [CCCallFunc actionWithTarget: globalMap selector: @selector(animateMapPoints)],
                                        nil
                        ]
            ];
        } break;
    }
    
    [evilDoctor runAction:
                    [CCSequence actions:
                                    animation,
                                    [CCDelayTime actionWithDuration: 0.5f],
                                    [CCCallFunc actionWithTarget: self selector: @selector(runRandomAnimation)],
                                    nil
                    ]
    ];
}

- (void) runStartAnimation
{
    CCAnimationCache *ac = [CCAnimationCache sharedAnimationCache];
    
    CCAction *eyesAnimation = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorEyes"]
                                        restoreOriginalFrame: NO];
    CCAction *laughAnimation = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorLaugh"]
                                        restoreOriginalFrame: NO];
    CCAction *switchAnimation = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorSwitch"]
                                        restoreOriginalFrame: NO];
    
    [evilDoctor runAction:
                    [CCSequence actions:
                                    [CCEaseBackOut actionWithAction:
                                                        [CCMoveTo actionWithDuration: 0.5f
                                                                            position: ccp(-24.0f, 0)
                                                        ]
                                    ],
                                    [CCCallFunc actionWithTarget: globalMap selector: @selector(enableWithChildren)],
                                    [CCDelayTime actionWithDuration: 0.5f],
                                    eyesAnimation,
                                    [CCDelayTime actionWithDuration: 0.5f],
                                    laughAnimation,
                                    switchAnimation,
                                    [CCCallFunc actionWithTarget: globalMap selector: @selector(animateMapPoints)],
                                    [CCDelayTime actionWithDuration: 0.5f],
                                    [CCCallFunc actionWithTarget: self selector: @selector(runRandomAnimation)],
                                    nil
                    ]
    ];
}

#pragma mark -

#pragma mark update
- (void) update: (ccTime) dt
{
//    static float mapPointAnimationDelayTime = 5.0f;
//    
//    mapPointAnimationDelayTime -= dt;
//    
//    if(mapPointAnimationDelayTime < 0)
//    {
//        mapPointAnimationDelayTime = 4.0f + (float)(arc4random()%200)/100.0f;
//        
//        [globalMap animateMapPoints];
//    }
}

@end
