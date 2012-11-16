//
//  GameDifficultyPopup.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundsConfig.h"

#import "MapDifficultyPopup.h"

#import "GameConfig.h"


@interface MapDifficultyPopup()

- (void) showAndEnable;
- (void) hideAndClose;

@end

static NSString *itemHeaders[kMaxGameDifficulty + 1] = {
    @"Normal", @"Hard", @"Ultra Hard", @"Insane"
};

@implementation MapDifficultyPopup

#pragma mark init and dealloc
- (id) initWithDelegate: (id<MapDifficultyPopupDelegate>) delegate_
{
    if(self = [super initWithDelegate: delegate_])
    {
        // background
        background = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 255)];
        [self addChild: background];
        
        // header
        header = [CCLabelBMFont labelWithString: @"Select Difficulty" fntFile: kFontDifficulty];
        header.anchorPoint = ccp(0.5f, 1);
        header.position = ccp(kScreenCenterX, kScreenHeight - 8.0f);
        header.color = ccc3(0, 255, 0);
        [self addChild: header];
        
        
        CCMenu *menu;
        CCLabelBMFont *label;
        
        // difficulty buttons
        menu = [CCMenu menuWithItems: nil];
        for(int i = [self.delegate minMapDifficulty]; i < kMaxGameDifficulty + 1; i++)
        {
            label = [CCLabelBMFont labelWithString: itemHeaders[i]
                                           fntFile: kFontDifficulty];
            
            difficultyBtn[i] = [CCMenuItemLabel itemWithLabel: label
                                                       target: self
                                                     selector: @selector(difficultyBtnCallback:)];
            
            [menu addChild: difficultyBtn[i] z: 0 tag: i];
        }
        
        [menu alignItemsVerticallyWithPadding: -8.0f];
        menu.position = ccp(kScreenCenterX, kScreenCenterY + 48.0f);
        [self addChild: menu];
        
        // arcade mode button
        arcadeModeBtn = [CCMenuItemLabel itemWithLabel: [CCLabelBMFont labelWithString: @"Arcade Mode" fntFile: kFontDifficulty]
                                                target: self
                                              selector: @selector(arcadeModeBtnCallback)];
        arcadeModeBtn.color = ccc3(255, 165, 0);
        arcadeModeBtn.scale = 1.1f;
        
        menu = [CCMenu menuWithItems: arcadeModeBtn, nil];
        menu.position = ccp(kScreenCenterX, kScreenCenterY/2 + 32.0f);
        [self addChild: menu];
        
        // close popup button
        label = [CCLabelBMFont labelWithString: @"Back" fntFile: kFontDifficulty];
        closePopupBtn = [CCMenuItemLabel itemWithLabel: label
                                                target: self
                                              selector: @selector(closePopupBtnCallback)];
        [(CCMenuItemLabel *)closePopupBtn setColor: ccc3(150, 0, 0)];
        closePopupBtn.scale = 0.9f;
        
        menu = [CCMenu menuWithItems: closePopupBtn, nil];
        menu.position = ccp(kScreenCenterX, 8.0f + closePopupBtn.contentSize.height/2);
        [self addChild: menu];
    }
    
    return self;
}

+ (id) popupWithDelegate: (id<MapDifficultyPopupDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (id<MapDifficultyPopupDelegate>) delegate
{
    return (id<MapDifficultyPopupDelegate>)delegate;
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
    
    header.position = ccp(header.position.x, header.position.y + 64.0f);
    [header runAction: [CCEaseBackOut actionWithAction: [CCMoveBy actionWithDuration: 0.2f position: ccp(0, -64.0f)]]];
    
    for(int i = [self.delegate minMapDifficulty]; i < kMaxGameDifficulty + 1; i++)
    {
        difficultyBtn[i].scale = 0;
        [difficultyBtn[i] runAction:
                                [CCSequence actions:
                                                [CCDelayTime actionWithDuration: i*0.03f],
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
    
    
    arcadeModeBtn.scale = 0;
    [arcadeModeBtn runAction:
                    [CCSequence actions:
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
                                            [CCDelayTime actionWithDuration: 0.12f],
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
    
    for(int i = kMaxGameDifficulty; i >= [self.delegate minMapDifficulty]; i--)
    {
        [difficultyBtn[i] runAction:
                                [CCSequence actions:
                                                [CCDelayTime actionWithDuration: (i + 1)*0.03f],
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
    
    [arcadeModeBtn runAction:
                        [CCSequence actions:
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
- (void) difficultyBtnCallback: (CCNode *) sender
{
    [self.delegate mapDifficultyChanged: sender.tag];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) arcadeModeBtnCallback
{
    [self.delegate mapDifficultyChanged: GameDifficultyArcade];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) closePopupBtnCallback
{
    [self disableWithChildren];
    [self hideAndClose];
    
    PLAY_BUTTON_CLICK_SOUND();
}

@end
