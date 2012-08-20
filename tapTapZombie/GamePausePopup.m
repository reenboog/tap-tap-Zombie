//
//  GamePausePopup.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePausePopup.h"

#import "GameConfig.h"

#import "Game.h"


@interface GamePausePopup()

- (void) showAndEnable;
- (void) hideAndClose;

@end


@implementation GamePausePopup

#pragma mark init and dealloc
- (id) initWithDelegate: (id<CCPopupLayerDelegate>) delegate_
{
    if(self = [super initWithDelegate: delegate_])
    {
        CCMenu *menu;
        CCLabelBMFont *label;
        
        // background
        background = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 255)];
        [self addChild: background];
        
        // buttons
        label = [CCLabelBMFont labelWithString: @"reset" fntFile: kDefaultGameFont];
        resetBtn = [CCMenuItemLabel itemWithLabel: label
                                           target: self 
                                         selector: @selector(resetBtnCallback)];
        
        label = [CCLabelBMFont labelWithString: @"exit" fntFile: kDefaultGameFont];
        exitBtn = [CCMenuItemLabel itemWithLabel: label
                                          target: self 
                                        selector: @selector(exitBtnCallback)];
        
        menu = [CCMenu menuWithItems: resetBtn, exitBtn, nil];
        [menu alignItemsVertically];
        menu.position = ccp(kScreenCenterX, kScreenCenterY);
        [self addChild: menu];
        
        // close popup button
        label = [CCLabelBMFont labelWithString: @"back" fntFile: kDefaultGameFont];
        closePopupBtn = [CCMenuItemLabel itemWithLabel: label
                                                target: self
                                              selector: @selector(closePopupBtnCallback)];
        
        menu = [CCMenu menuWithItems: closePopupBtn, nil];
        menu.position = ccp(kScreenCenterX, 48.0f);
        [self addChild: menu];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

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
    
    [closePopupBtn runAction:
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
- (void) resetBtnCallback
{
    [[Game sharedGame] resetGame];
    
    [self disableWithChildren];
    
    [self hideAndClose];
}

- (void) exitBtnCallback
{
    [[Game sharedGame] exitGame];
}

- (void) closePopupBtnCallback
{
    [self disableWithChildren];
    
    [self hideAndClose];
}

@end
