//
//  GameOverPopup.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverPopup.h"

#import "GameConfig.h"


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
    
    return [NSString stringWithFormat: @"%.2d:%.2d", m, s];
}

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
        
        // game over status
        
        NSString *statusStr = self.delegate.isGameFailed || self.delegate.isArcadeGame ? @"Game over" : @"You are winner!";
        statusLabel = [CCLabelBMFont labelWithString: statusStr fntFile: kFontDefault];
        statusLabel.position = ccp(kScreenCenterX, kScreenCenterY + 96.0f);
        [self addChild: statusLabel];
        
        NSString *timeStr = [NSString stringWithFormat: @"time %@", ccTimeToString(self.delegate.timer)];
        timeLabel = [CCLabelBMFont labelWithString: timeStr fntFile: kFontDefault];
        timeLabel.position = ccp(kScreenCenterX, kScreenCenterY + 64.0f);
        [self addChild: timeLabel];
        
        NSString *perfectTapsStr = [NSString stringWithFormat: @"perfect taps: %i", self.delegate.longestPerfectCycleLength];
        perfectTapsLabel = [CCLabelBMFont labelWithString: perfectTapsStr fntFile: kFontDefault];
        perfectTapsLabel.position = ccp(kScreenCenterX, kScreenCenterY + 32.0f);
        [self addChild: perfectTapsLabel];
        
        NSString *scoreStr = [NSString stringWithFormat: @"score: %.0f", self.delegate.score];
        scoreLabel = [CCLabelBMFont labelWithString: scoreStr fntFile: kFontDefault];
        scoreLabel.position = ccp(kScreenCenterX, kScreenCenterY + 0.0f);
        [self addChild: scoreLabel];
        
        // buttons
        btnSprite = [CCSprite spriteWithFile: @"buttons/resetBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/resetBtnOn.png"];
        resetBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                           selectedSprite: btnOnSprite
                                                   target: self 
                                                 selector: @selector(resetBtnCallback)];
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/exitBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/exitBtnOn.png"];
        exitBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnOnSprite
                                                  target: self 
                                                selector: @selector(exitBtnCallback)];
        
        menu = [CCMenu menuWithItems: resetBtn, exitBtn, nil];
        [menu alignItemsHorizontally];
        menu.position = ccp(kScreenCenterX, kScreenCenterY - 48.0f);
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
                                    [CCFadeTo actionWithDuration: 0.3f opacity: 150],
                                    [CCCallFunc actionWithTarget: self selector: @selector(enableWithChildren)],
                                    nil
                    ]
    ];
    
    resetBtn.scale = 0;
    [resetBtn runAction:
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
    
    exitBtn.scale = 0;
    [exitBtn runAction:
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
    
    statusLabel.scale = 0;
    [statusLabel runAction:
                    [CCSpawn actions:
                                [CCFadeIn actionWithDuration: 0.2f],
                                [CCEaseBackOut actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.3f scale: 1.0f]
                                ],
                                nil
                    ]
    ];
    
    timeLabel.scale = 0;
    [timeLabel runAction:
                    [CCSpawn actions:
                                [CCFadeIn actionWithDuration: 0.2f],
                                [CCEaseBackOut actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.3f scale: 1.0f]
                                ],
                                nil
                    ]
    ];
    
    perfectTapsLabel.scale = 0;
    [perfectTapsLabel runAction:
                    [CCSpawn actions:
                                [CCFadeIn actionWithDuration: 0.2f],
                                [CCEaseBackOut actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.3f scale: 1.0f]
                                ],
                                nil
                    ]
    ];
    
    scoreLabel.scale = 0;
    [scoreLabel runAction:
                    [CCSpawn actions:
                                [CCFadeIn actionWithDuration: 0.2f],
                                [CCEaseBackOut actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.3f scale: 1.0f]
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
    
    [resetBtn runAction:
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
    
    [exitBtn runAction:
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
    
    [statusLabel runAction:
                    [CCSpawn actions:
                                [CCFadeOut actionWithDuration: 0.2f],
                                [CCEaseBackIn actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.2f scale: 0]
                                ],
                                nil
                    ]
    ];
    
    [timeLabel runAction:
                    [CCSpawn actions:
                                [CCFadeOut actionWithDuration: 0.2f],
                                [CCEaseBackIn actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.2f scale: 0]
                                ],
                                nil
                    ]
    ];
    
    [perfectTapsLabel runAction:
                    [CCSpawn actions:
                                [CCFadeOut actionWithDuration: 0.2f],
                                [CCEaseBackIn actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.2f scale: 0]
                                ],
                                nil
                    ]
    ];
    
    [scoreLabel runAction:
                    [CCSpawn actions:
                                [CCFadeOut actionWithDuration: 0.2f],
                                [CCEaseBackIn actionWithAction:
                                                    [CCScaleTo actionWithDuration: 0.2f scale: 0]
                                ],
                                nil
                    ]
    ];
}

#pragma mark -

#pragma mark callbacks
- (void) resetBtnCallback
{
    [self.delegate restart];
    
    [self disableWithChildren];
    [self hideAndClose];
}

- (void) exitBtnCallback
{
    [self.delegate exit];
}

#pragma mark -

@end
