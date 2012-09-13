//
//  SelectGameDifficultyPopup.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameDifficultyPopup.h"

#import "GameConfig.h"


@interface GameDifficultyPopup()

- (void) showAndEnable;
- (void) hideAndClose;

@end


@implementation GameDifficultyPopup

#pragma mark init and dealloc
- (id) initWithDelegate: (id<CCPopupLayerDelegate>) delegate_
{
    if(self = [super init])
    {
        CCMenu *menu;
        CCLabelBMFont *label;
        
        // background
        background = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 255)];
        [self addChild: background];
        
        // difficulty buttons
        menu = [CCMenu menuWithItems: nil];
        for(int i = 0; i < kMaxGameDifficulty + 1; i++)
        {
            label = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"difficulty %i", i] 
                                           fntFile: kDefaultGameFont];
            
            difficultyBtn[i] = [CCMenuItemLabel itemWithLabel: label
                                                       target: self
                                                     selector: @selector(difficultyBtnCallback:)];
            
            [menu addChild: difficultyBtn[i] z: 0 tag: i];
        }
        
        [menu alignItemsVertically];
        menu.position = ccp(kScreenCenterX, kScreenCenterY + 64.0f);
        [self addChild: menu];
        
        // close popup button
        label = [CCLabelBMFont labelWithString: @"cancel" fntFile: kDefaultGameFont];
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
    
    for(int i = 0; i < kMaxGameDifficulty + 1; i++)
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
    
    for(int i = kMaxGameDifficulty; i >= 0; i--)
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
    [Game sharedGame].difficulty = sender.tag;
    [[Game sharedGame] runGameScene];
}

- (void) closePopupBtnCallback
{
    [self disableWithChildren];
    [self hideAndClose];
}

@end
