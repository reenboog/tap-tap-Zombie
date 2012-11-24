//
//  GamePausePopup.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundsConfig.h"

#import "GamePausePopup.h"

#import "GameConfig.h"


@interface GamePausePopup()

- (void) showAndEnable;
- (void) hideAndClose;

@end


@implementation GamePausePopup

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GamePausePopupDelegate>) delegate_
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
        header = [CCLabelBMFont labelWithString: @"Pause" fntFile: kFontDifficulty];
        header.anchorPoint = ccp(0.5f, 1);
        header.position = ccp(kScreenCenterX, kScreenHeight - 8.0f);
        header.color = ccc3(0, 255, 0);
        [self addChild: header];
        
        // info
        CCLabelBMFont *name;
        CCLabelBMFont *value;
        
        float shiftTop = -24.0f;
        
        // score
        score = [CCNode node];
        [self addChild: score];
        
        name = [CCLabelBMFont labelWithString: @"Score:" fntFile: kFontDifficulty];
        name.anchorPoint = ccp(1, 0.5f);
        [score addChild: name];
        value = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @" %.0f", [self.delegate score]]
                                       fntFile: kFontDifficulty];
        value.anchorPoint = ccp(0, 0.5f);
        [score addChild: value];
        float nw = name.contentSize.width;
        float vw = value.contentSize.width;
        score.position = ccp(kScreenCenterX + (nw + vw)/2 - vw, kScreenHeight - 72.0f + shiftTop);
        
        // best score
        bestScore = [CCNode node];
        [self addChild: bestScore];
        
        name = [CCLabelBMFont labelWithString: @"Best score:" fntFile: kFontDifficulty];
        name.anchorPoint = ccp(1, 0.5f);
        [bestScore addChild: name];
        value = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @" %.0f", [self.delegate bestScore]]
                                       fntFile: kFontDifficulty];
        value.anchorPoint = ccp(0, 0.5f);
        [bestScore addChild: value];
        nw = name.contentSize.width;
        vw = value.contentSize.width;
        bestScore.position = ccp(kScreenCenterX + (nw + vw)/2 - vw, kScreenHeight - 104.0f + shiftTop);
        
        // zombies left
        zombiesLeft = [CCNode node];
        [self addChild: zombiesLeft];
        
        name = [CCLabelBMFont labelWithString: @"Zombies left:" fntFile: kFontDifficulty];
        name.anchorPoint = ccp(1, 0.5f);
        [zombiesLeft addChild: name];
        value = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @" %i", [self.delegate zombiesLeft]]
                                       fntFile: kFontDifficulty];
        value.anchorPoint = ccp(0, 0.5f);
        [zombiesLeft addChild: value];
        nw = name.contentSize.width;
        vw = value.contentSize.width;
        zombiesLeft.position = ccp(kScreenCenterX + (nw + vw)/2 - vw, kScreenHeight - 136.0f + shiftTop);
        zombiesLeft.visible = ![self.delegate isArcadeGame];
        
        // buttons
        btnSprite = [CCSprite spriteWithFile: @"buttons/rightBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/rightBtnOn.png"];
        closePopupBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                                selectedSprite: btnOnSprite
                                                        target: self
                                                      selector: @selector(closePopupBtnCallback)];
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/resetBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/resetBtnOn.png"];
        restartBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                             selectedSprite: btnOnSprite
                                                     target: self 
                                                   selector: @selector(restartBtnCallback)];
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/exitBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/exitBtnOn.png"];
        exitBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnOnSprite
                                                  target: self 
                                                selector: @selector(exitBtnCallback)];
        
        menu = [CCMenu menuWithItems: exitBtn, restartBtn, closePopupBtn, nil];
        [menu alignItemsHorizontally];
        menu.position = ccp(kScreenCenterX, kScreenCenterY - 96.0f);
        [self addChild: menu];
    }
    
    return self;
}

+ (id) popupWithDelegate: (id<GamePausePopupDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

- (id<GamePausePopupDelegate>) delegate
{
    return (id<GamePausePopupDelegate>) delegate;
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
    score.scale = 0;
    [score runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0],
                                    [CCEaseBackOut actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 1]
                                    ],
                                    nil
                    ]
    ];
    
    
    bestScore.scale = 0;
    [bestScore runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.03f],
                                    [CCEaseBackOut actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 1]
                                    ],
                                    nil
                    ]
    ];
    
    
    zombiesLeft.scale = 0;
    [zombiesLeft runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.06f],
                                    [CCEaseBackOut actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 1]
                                    ],
                                    nil
                    ]
    ];
    
    // buttons
    closePopupBtn.scale = 0;
    [closePopupBtn runAction:
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
    
    
    restartBtn.scale = 0;
    [restartBtn runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.03f],
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
    [score runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0],
                                    [CCEaseBackIn actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 0]
                                    ],
                                    nil
                    ]
    ];
    
    
    [bestScore runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.03f],
                                    [CCEaseBackIn actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 0]
                                    ],
                                    nil
                    ]
    ];
    
    
    [zombiesLeft runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.06f],
                                    [CCEaseBackIn actionWithAction:
                                                        [CCScaleTo actionWithDuration: 0.2f 
                                                                                scale: 0]
                                    ],
                                    nil
                    ]
    ];

    // buttons
    [closePopupBtn runAction:
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
    
    [restartBtn runAction:
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

#pragma mark callbacks
- (void) restartBtnCallback
{
    [self.delegate restart];
    
    [self disableWithChildren];
    [self hideAndClose];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) exitBtnCallback
{
    [self.delegate exit];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) closePopupBtnCallback
{
    [self disableWithChildren];
    [self hideAndClose];
    
    PLAY_BUTTON_CLICK_SOUND();
}


#pragma mark -

@end
