//
//  MainMenuLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "SoundsConfig.h"

#import "MainMenuLayer.h"
#import "ShopPopup.h"

#import "GlobalMapLayer.h"

#import "WaveCache.h"
#import "AnimationLoader.h"
#import "MapCache.h"

#import "GameScene.h"

#import "MapDifficultyPopup.h"

#import "GameLoadingScene.h"

#import "Settings.h"



@interface MainMenuLayer()
- (void) runStartAnimation;
@end


@implementation MainMenuLayer

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] init];
    
    [scene addChild: mainMenuLayer];
    
    [mainMenuLayer release];
    
    return scene;
}

- (void) loadResources
{
    [[CCTextureCache sharedTextureCache] addImage: @"mainMenu/evilDoctor.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"mainMenu/evilDoctor.plist"];
    [[CCTextureCache sharedTextureCache] addImage: @"mainMenu/evilDoctorGhost.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"mainMenu/evilDoctorGhost.plist"];
    [[CCTextureCache sharedTextureCache] addImage: @"mainMenu/evilDoctorGhost1.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"mainMenu/evilDoctorGhost1.plist"];
    
    [AnimationLoader loadAnimationsWithPlist: @"mainMenu/animations"];
    
    [[CCTextureCache sharedTextureCache] addImage: @"shop/icons/shopIcons.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"shop/icons/shopIcons.plist"];
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        [self loadResources];
        
        globalMap = [GlobalMapLayer globalMapLayerWithDelegate: self];
        [self addChild: globalMap z: -1];
        [globalMap disableWithChildren];
        
        // main menu
//        CCMenu *menu;
        
        shopBtn = [CCMenuItemImage  itemFromNormalImage: @"buttons/shopBtn.png"
                                          selectedImage: @"buttons/shopBtnOn.png"
                                                 target: self
                                               selector: @selector(shopBtnCallback)];
        shopBtn.anchorPoint = ccp(1, 1);
        shopBtn.scale = 0.5f;
        
        gameCenterBtn = [CCMenuItemImage  itemFromNormalImage: @"buttons/scoresBtn.png"
                                                selectedImage: @"buttons/scoresBtnOn.png"
                                                       target: self
                                                     selector: @selector(gameCenterBtnCallback)];
        gameCenterBtn.anchorPoint = ccp(1, 1);
        gameCenterBtn.scale = 0.5f;
        
        twitterBtn = [CCMenuItemImage  itemFromNormalImage: @"buttons/twitterBtn.png"
                                             selectedImage: @"buttons/twitterBtnOn.png"
                                                    target: self
                                                  selector: @selector(twitterBtnCallback)];
        twitterBtn.anchorPoint = ccp(1, 1);
        twitterBtn.scale = 0.5f;
        
        facebookBtn = [CCMenuItemImage  itemFromNormalImage: @"buttons/facebookBtn.png"
                                              selectedImage: @"buttons/facebookBtnOn.png"
                                                     target: self
                                                   selector: @selector(facebookBtnCallback)];
        facebookBtn.anchorPoint = ccp(1, 1);
        facebookBtn.scale = 0.5f;
        
        topMenu = [CCMenu menuWithItems: shopBtn, gameCenterBtn, twitterBtn, facebookBtn, nil];
        [topMenu alignItemsHorizontally];
        topMenu.position = ccp(kScreenWidth - 16.0f - shopBtn.contentSize.width*0.75f, kScreenHeight - 8.0f + kScreenCenterY/2);
        [self addChild: topMenu];
        
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
        
        // blackout
        blackOut = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 255)];
        [blackOut setOpacity: 0];
        [self addChild: blackOut];
        
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
    
    gameStatus.isStarted = NO;
    gameStatus.isActive = NO;
    
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
    
    
    [topMenu runAction:
                [CCEaseBackIn actionWithAction:
                                    [CCMoveBy actionWithDuration: 0.3f
                                                        position: ccp(0, kScreenCenterY/2)]
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
    
    [topMenu runAction:
                [CCEaseBackOut actionWithAction:
                                    [CCMoveBy actionWithDuration: 0.3f
                                                        position: ccp(0, -kScreenCenterY/2)]
                ]
    ];
}

#pragma mark -

#pragma mark GlobalMapDelegate methods implementation

- (void) mapChanged: (int) mapIndex_
{
    mapIndex = mapIndex_;
    
    if([Settings sharedSettings].gameCycle > 0)
    {
        NSNumber *i = [NSNumber numberWithInt: mapIndex];
        
        if([[Settings sharedSettings].arcadeMaps containsObject: i])
        {
            [self mapDifficultyChanged: GameDifficultyArcade];
            
            return;
        }
    }
    
    [MapDifficultyPopup showOnRunningSceneWithDelegate: self];
}

#pragma mark -

#pragma mark GameDifficultyPopupDelegate methods implementation
- (void) mapDifficultyChanged: (GameDifficulty) mapDifficulty
{
    if(mapDifficulty == GameDifficultyArcade)
    {
        mapDifficulty = [self minMapDifficulty];
        runGameInArcadeMode = YES;
    }
    else
    {
        runGameInArcadeMode = NO;
    }
    
    // start game on map
    Map *map = [[MapCache sharedMapCache] mapAtIndex: mapIndex withDifficulty: mapDifficulty];
    GameLoadingScene *loadingScene = [GameLoadingScene sceneWithMap: map];
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: loadingScene
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

- (int) minMapDifficulty
{
    return [Settings sharedSettings].gameCycle;
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
            
            int d = arc4random()%20;
            
            if(d < 8)
            {
                [globalMap showFirs];
            }
            else if(d < 13)
            {
                [blackOut runAction:
                                [CCSequence actions:
                                                [CCDelayTime actionWithDuration: 0.5f],
                                                [CCFadeTo actionWithDuration: 0.06f opacity: 255],
                                                [CCDelayTime actionWithDuration: 0.06f],
                                                [CCFadeTo actionWithDuration: 0.06f opacity: 0],
                                                [CCDelayTime actionWithDuration: 0.06f],
                                                [CCFadeTo actionWithDuration: 0.06f opacity: 255],
                                                [CCDelayTime actionWithDuration: 0.06f],
                                                [CCFadeTo actionWithDuration: 0.06f opacity: 0],
                                                nil
                                ]
                ];
            }
            else if(d < 18)
            {
                CCFiniteTimeAction *becomesGhost = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorBecomesGhost"]
                                                             restoreOriginalFrame: NO];
                CCFiniteTimeAction *ghost = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorGhost"]
                                                      restoreOriginalFrame: NO];
                CCFiniteTimeAction *afterGhost = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorAfterGhost"]
                                                           restoreOriginalFrame: NO];
                CCFiniteTimeAction *becomesHuman = [CCAnimate actionWithAnimation: [ac animationByName: @"evilDoctorBecomesHuman"]
                                                             restoreOriginalFrame: NO];
                
                CCFiniteTimeAction *ghostAnimation = [CCSequence actions:
                        animation,
                        becomesGhost,
                        ghost,
                        becomesHuman,
                        afterGhost,
                        nil
                ];
                
                
                [evilDoctor runAction:
                                [CCSequence actions:
                                                ghostAnimation,
                                                [CCDelayTime actionWithDuration: 0.5f],
                                                [CCCallFunc actionWithTarget: self selector: @selector(runRandomAnimation)],
                                                nil
                                ]
                ];
                
                return;
            }
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
    
    [topMenu runAction:
                [CCEaseBackOut actionWithAction:
                                    [CCMoveBy actionWithDuration: 0.3f
                                                        position: ccp(0, -kScreenCenterY/2)]
                ]
    ];
}

#pragma mark -

#pragma mark callbacks
- (void) gameCenterBtnCallback
{
    leaderboardViewController = [[UIViewController alloc] init];
    
    GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
    
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        [[[CCDirector sharedDirector] openGLView] addSubview: leaderboardViewController.view];
        [leaderboardViewController presentModalViewController: leaderboardController animated: NO];
        
        leaderboardController.view.transform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(0.0f));
        //        leaderboardController.view.bounds = CGRectMake(0, 0, 480, 320);
        leaderboardController.view.center = CGPointMake(240, 160);
    }
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) shopBtnCallback
{
    [ShopPopup showOnRunningSceneWithDelegate: self];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) twitterBtnCallback
{
    
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) facebookBtnCallback
{
    
    
    PLAY_BUTTON_CLICK_SOUND();
}

#pragma mark -

#pragma mark game kit
-(void) leaderboardViewControllerDidFinish: (GKLeaderboardViewController *) viewController
{
    [leaderboardViewController dismissModalViewControllerAnimated: NO];
    [leaderboardViewController.view removeFromSuperview];
    
    [leaderboardViewController release];
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
