//
//  ShopPopup.m
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "SoundsConfig.h"

#import "ShopPopup.h"

#import "ShopLayer.h"

#import "Settings.h"


@interface ShopPopup()

- (void) showAndEnable;
- (void) hideAndClose;

@end


@implementation ShopPopup

#pragma mark init and dealloc
- (id) initWithDelegate:(id<CCPopupLayerDelegate>)delegate_ currentPageItem: (NSString *) item
{
    if(self = [super initWithDelegate: delegate_])
    {
        
        CCSprite *btnSprite;
        CCSprite *btnSpriteOn;
        CCMenu *menu;
        
        // background
        background = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 255)];
        [self addChild: background];
        
        // shop layer
        shopLayer = [ShopLayer shopLayerWithCurrentPageItem: item];
        [self addChild: shopLayer];
        
        // close popup button
        btnSprite = [CCSprite spriteWithFile: @"buttons/returnBtn.png"];
        btnSpriteOn = [CCSprite spriteWithFile: @"buttons/returnBtnOn.png"];
        closePopupBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                                selectedSprite: btnSpriteOn
                                                        target: self
                                                      selector: @selector(closePopupBtnCallback)];
        menu = [CCMenu menuWithItems: closePopupBtn, nil];
        menu.position = ccp(closePopupBtn.contentSize.width/2 + 8.0f, closePopupBtn.contentSize.height/2 + 8.0f);
        [self addChild: menu z: 0];
    }
    
    return self;
}

- (id) initWithDelegate: (id<CCPopupLayerDelegate>) delegate_
{
    return [self initWithDelegate: delegate_ currentPageItem: nil];
}

- (void) dealloc
{
    [super dealloc];
}

+ (void) showOnRunningSceneWithDelegate: (id<CCPopupLayerDelegate>) delegate currentPageItem: (NSString *) itemName;
{
    [[[CCDirector sharedDirector] runningScene] addChild: [[[self alloc] initWithDelegate: delegate currentPageItem: itemName] autorelease] z: kPopupZOrder];
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

#pragma mark start/end (with animation)
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
    
    [shopLayer showWithAnimationAndEnable];
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
    
    [shopLayer disableAndHideWithAnimation];
}

#pragma mark -

#pragma mark callbacks
- (void) closePopupBtnCallback
{
    [self disableWithChildren];
    [self hideAndClose];
    
    PLAY_BUTTON_CLICK_SOUND();
}

@end
