//
//  GameOverPopup.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundsConfig.h"

#import "GameOverPopup.h"

#import "GameConfig.h"

#import "ShopPopup.h"
#import "Shop.h"

#import "Settings.h"

#import "MapCache.h"


@interface GameOverPopup()

- (void) showAndEnable;
- (void) hideAndClose;

@end

// return string with format "mm:ss"
static NSString* ccTimeToString(ccTime time)
{
    int t = (int)time;
    int h = t/3600;
    int m = (t - h*3600)/60;
    int s = t - h*3600 - m*60;
    
    return [NSString stringWithFormat: @"%.2d.%.2d", m, s];
}

#define kGameOverStatusWinCount 3
static NSString *gameOverStatusWin[kGameOverStatusWinCount] = {
    @"Not bad!", @"Good job!", @"Level cleared!"
};

#define kGameOverStatusFailCount 4
static NSString *gameOverStatusFail[kGameOverStatusFailCount] = {
    @"Try again!", @"You need upgrades!", @"So close!", @"Don't give up! Replay!"
};

@implementation GameOverPopup

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GameOverPopupDelegate>) delegate_
{
    if(self = [super initWithDelegate: delegate_])
    {
        CCMenu *menu;
        CCSprite *btnSprite;
        CCSprite *btnOnSprite;
        
        // background
        background = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 255)];
        [self addChild: background];
        
        // header
        NSString *headerStr;
        float headerScale = 1.0f;
        if([[MapCache sharedMapCache] allMapsPassed])
        {
            headerStr = @"Now try the same in Insane mode!";
            headerScale = 0.9f;
            
            [[MapCache sharedMapCache] nextCycle];
        }
        else if(self.delegate.isArcadeGame || !self.delegate.isGameFailed)
        {
            headerStr = gameOverStatusWin[arc4random()%kGameOverStatusWinCount];
            
            if([Settings sharedSettings].gameCycle > 0)
            {
                NSNumber *i = [NSNumber numberWithInt: [self.delegate map].index];
                
                if([[Settings sharedSettings].arcadeMaps containsObject: i])
                {
                    [[Settings sharedSettings].arcadeMaps removeObject: i];
                    [[Settings sharedSettings] save];
                }
            }
        }
        else
        {
            headerStr = gameOverStatusFail[arc4random()%kGameOverStatusFailCount];
        }
        
        header = [CCLabelBMFont labelWithString: headerStr fntFile: kFontDifficulty];
        header.anchorPoint = ccp(0.5f, 1);
        header.position = ccp(kScreenCenterX, kScreenHeight - 8.0f);
        header.color = ccc3(0, 255, 0);
        [self addChild: header];
        header.scale = headerScale;
        
        // info
        CCLabelBMFont *name;
        CCLabelBMFont *value;
        
        // time
        time = [CCNode node];
        time.position = ccp(kScreenCenterX, kScreenCenterY + 72.0f);
        [self addChild: time];
        
        name = [CCLabelBMFont labelWithString: @"Time:" fntFile: kFontDifficulty];
        name.anchorPoint = ccp(1, 0.5f);
        [time addChild: name];
        value = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @" %@", ccTimeToString(self.delegate.timer)]
                                       fntFile: kFontDifficulty];
        value.anchorPoint = ccp(0, 0.5f);
        [time addChild: value];
        
        // perfect taps
        perfectTaps = [CCNode node];
        perfectTaps.position = ccp(kScreenCenterX, kScreenCenterY + 40.0f);
        [self addChild: perfectTaps];
        
        name = [CCLabelBMFont labelWithString: @"Perfect taps:" fntFile: kFontDifficulty];
        name.anchorPoint = ccp(1, 0.5f);
        [perfectTaps addChild: name];
        value = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @" %i", self.delegate.longestPerfectCycleLength]
                                       fntFile: kFontDifficulty];
        value.anchorPoint = ccp(0, 0.5f);
        [perfectTaps addChild: value];
        
        // perfect taps
        score = [CCNode node];
        score.position = ccp(kScreenCenterX, kScreenCenterY + 8.0f);
        [self addChild: score];
        
        name = [CCLabelBMFont labelWithString: @"Score:" fntFile: kFontDifficulty];
        name.anchorPoint = ccp(1, 0.5f);
        [score addChild: name];
        value = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @" %.0f", self.delegate.score]
                                       fntFile: kFontDifficulty];
        value.anchorPoint = ccp(0, 0.5f);
        [score addChild: value];
        
        // resurrection
        int resurrectionNum = [[[Shop sharedShop] itemWithName: kResurrection] amount];
        NSString *resurrectionText = [NSString stringWithFormat: @"Use Resurrection (%i)", resurrectionNum];
        resurrection = [CCMenuItemLabel itemWithLabel: [CCLabelBMFont labelWithString: resurrectionText fntFile: kFontDifficulty]
                                               target: self
                                             selector: @selector(resurrection)];
        resurrection.color = ccc3(255, 165, 0);
        
        menu = [CCMenu menuWithItems: resurrection, nil];
        menu.position = ccp(kScreenCenterX, kScreenCenterY - 32.0f);
        [self addChild: menu];
        
        if(self.delegate.isArcadeGame || !self.delegate.isGameFailed)
        {
            resurrection.visible = NO;
            resurrection.isEnabled = NO;
        }
        
        // buttons
        btnSprite = [CCSprite spriteWithFile: @"buttons/exitBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/exitBtnOn.png"];
        exitBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnOnSprite
                                                  target: self 
                                                selector: @selector(exitBtnCallback)];
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/shopBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/shopBtnOn.png"];
        shopBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                           selectedSprite: btnOnSprite
                                                   target: self 
                                                 selector: @selector(shopBtnCallback)];
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/resetBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/resetBtnOn.png"];
        resetBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                           selectedSprite: btnOnSprite
                                                   target: self 
                                                 selector: @selector(resetBtnCallback)];
        
        menu = [CCMenu menuWithItems: exitBtn, shopBtn, resetBtn, nil];
        [menu alignItemsHorizontally];
        menu.position = ccp(kScreenCenterX, kScreenCenterY - 96.0f);
        [self addChild: menu];
    }
    
    return self;
}

+ (id) popupWithDelegate: (id<GameOverPopupDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

- (id<GameOverPopupDelegate>) delegate
{
    return (id<GameOverPopupDelegate>)delegate;
}

#pragma mark onEnter
- (void) onEnter
{
    [super onEnter];
    
    [self disableWithChildren];
    [self showAndEnable];
}

#pragma mark -

#pragma mark animations
- (void) showAndEnable
{
    [background setOpacity: 0];
    [background runAction:
                    [CCSequence actions:
                                    [CCFadeTo actionWithDuration: 0.3f opacity: 200],
                                    [CCCallFunc actionWithTarget: self selector: @selector(enableWithChildren)],
                                    nil
                    ]
    ];
    
    header.position = ccp(header.position.x, header.position.y + 64.0f);
    [header runAction: [CCEaseBackOut actionWithAction: [CCMoveBy actionWithDuration: 0.2f position: ccp(0, -64.0f)]]];
    
    // info
    time.scale = 0;
    [time runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0],
                                    [CCEaseBackOut actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 1]
                                    ],
                                    nil
                    ]
    ];
    
    
    perfectTaps.scale = 0;
    [perfectTaps runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.03f],
                                    [CCEaseBackOut actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 1]
                                    ],
                                    nil
                    ]
    ];
    
    
    resurrection.scale = 0;
    [resurrection runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.06f],
                                    [CCEaseBackOut actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 1]
                                    ],
                                    nil
                    ]
    ];
    
    // resurrection
    resurrection.scale = 0;
    [resurrection runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.09f],
                                    [CCEaseBackOut actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.15f
                                                                                scale: 1]
                                    ],
                                    nil
                    ]
    ];
    
    // buttons
    resetBtn.scale = 0;
    [resetBtn runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.06f],
                                    [CCSpawn actions:
                                                [CCEaseBackOut actionWithAction:
                                                                    [CCScaleTo actionWithDuration: 0.2f 
                                                                                            scale: 1]
                                                ],
                                                [CCFadeIn actionWithDuration: 0.15f],
                                                nil
                                    ],
                                    nil
                    ]
    ];
    
    shopBtn.scale = 0;
    [shopBtn runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.03f],
                                    [CCSpawn actions:
                                                [CCEaseBackOut actionWithAction:
                                                                    [CCScaleTo actionWithDuration: 0.2f 
                                                                                            scale: 0.666f]
                                                ],
                                                [CCFadeIn actionWithDuration: 0.15f],
                                                nil
                                    ],
                                    nil
                    ]
    ];
    
    exitBtn.scale = 0;
    [exitBtn runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0],
                                    [CCSpawn actions:
                                                [CCEaseBackOut actionWithAction:
                                                                    [CCScaleTo actionWithDuration: 0.2f 
                                                                                            scale: 1]
                                                ],
                                                [CCFadeIn actionWithDuration: 0.15f],
                                                nil
                                    ],
                                    nil
                    ]
    ];
}

- (void) hideAndClose
{
    [background runAction:
                    [CCSequence actions:
                                    [CCFadeTo actionWithDuration: 0.4f opacity: 0],
                                    [CCCallFunc actionWithTarget: self selector: @selector(removeFromParentWithCleanup)],
                                    nil
                    ]
    ];
    
    [header runAction: [CCEaseBackIn actionWithAction: [CCMoveBy actionWithDuration: 0.2f position: ccp(0, 64.0f)]]];
    
    // info
    [time runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0],
                                    [CCEaseBackIn actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 0]
                                    ],
                                    nil
                    ]
    ];
    
    
    [perfectTaps runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.03f],
                                    [CCEaseBackIn actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 0]
                                    ],
                                    nil
                    ]
    ];
    
    
    [score runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.06f],
                                    [CCEaseBackIn actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 0]
                                    ],
                                    nil
                    ]
    ];
    
    // resurrection
    [resurrection runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.09f],
                                    [CCEaseBackIn actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.15f
                                                                                scale: 0]
                                    ],
                                    nil
                    ]
    ];
    
    // buttons
    [resetBtn runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.06f],
                                    [CCSpawn actions:
                                                [CCEaseBackIn actionWithAction:
                                                                    [CCScaleTo actionWithDuration: 0.2f 
                                                                                            scale: 0]
                                                ],
                                                [CCFadeOut actionWithDuration: 0.2f],
                                                nil
                                    ],
                                    nil
                    ]
    ];
    
    [shopBtn runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.03f],
                                    [CCSpawn actions:
                                                [CCEaseBackIn actionWithAction:
                                                                    [CCScaleTo actionWithDuration: 0.2f 
                                                                                            scale: 0]
                                                ],
                                                [CCFadeOut actionWithDuration: 0.2f],
                                                nil
                                    ],
                                    nil
                    ]
    ];
    
    [exitBtn runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0],
                                    [CCSpawn actions:
                                                [CCEaseBackIn actionWithAction:
                                                                    [CCScaleTo actionWithDuration: 0.2f 
                                                                                            scale: 0]
                                                ],
                                                [CCFadeOut actionWithDuration: 0.2f],
                                                nil
                                    ],
                                    nil
                    ]
    ];
}

#pragma mark -

#pragma mark CCPopupLayerDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [self disableWithChildren];
}

- (void) popupDidFinishClosing: (CCPopupLayer *) popup
{
    int resurrectionNum = [[[Shop sharedShop] itemWithName: kResurrection] amount];
    [resurrection setString: [NSString stringWithFormat: @"Use Resurrection (%i)", resurrectionNum]];
    
    [self enableWithChildren];
}

#pragma mark -

#pragma mark callbacks
- (void) resetBtnCallback
{
    [self.delegate restart];
    
    [self disableWithChildren];
    [self hideAndClose];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) shopBtnCallback
{
    [ShopPopup showOnRunningSceneWithDelegate: self currentPageItem: kResurrection];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) exitBtnCallback
{
    [self.delegate exit];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) resurrection
{
    int resurrectionNum = [[[Shop sharedShop] itemWithName: kResurrection] amount];
    
    if(resurrectionNum < 1)
    {
        [ShopPopup showOnRunningSceneWithDelegate: self currentPageItem: kResurrection];
    }
    else
    {
        [resurrection setString: [NSString stringWithFormat: @"Use Resurrection (%i)", resurrectionNum]];
        
        [self.delegate resurrection];
        
        [self hideAndClose];
    }
    
    PLAY_BUTTON_CLICK_SOUND();
}

#pragma mark -

@end
