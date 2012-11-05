//
//  TutorialPopup.m
//  tap-tap-Zombie
//
//  Created by Alexander on 31.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "TutorialPopup.h"
#import "Settings.h"

#import "AnimationLoader.h"


#define kPicTag 11

@interface TutorialPopup ()
- (CCLayer *) pageWithPicture: (CCNode *) pic andDescription: (NSString *) desc;
- (CCLayer *) bonusPageWithPicture: (CCNode *) pic andDescription: (NSString *) desc;

- (CCLayer *) ghostsPage;
- (CCLayer *) bonusPage;
- (CCLayer *) bombPage;
- (CCLayer *) timeBonusPage;
- (CCLayer *) shieldPage;
@end

@implementation TutorialPopup

#pragma mark init and dealloc
- (id) initWithDelegate: (id<CCPopupLayerDelegate>) delegate_ pages: (NSArray *) pages
{
    if(self = [super initWithDelegate: delegate_])
    {
        background = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 150)];
        [self addChild: background];
        
        // buttons
        CCMenu *menu;
        
        rightBtn = [CCMenuItemImage itemFromNormalImage: @"buttons/rightBtn.png"
                                          selectedImage: @"buttons/rightBtnOn.png"
                                                 target: self
                                               selector: @selector(rightBtnCallback)];
        menu = [CCMenu menuWithItems: rightBtn, nil];
        menu.position = ccp(kScreenWidth - 8.0f - rightBtn.contentSize.width/2, kScreenCenterY);
        rightBtn.position = ccp(0, 0);
        rightBtn.scale = 0.8f;
        [self addChild: menu z: 0];
        
        leftBtn = [CCMenuItemImage itemFromNormalImage: @"buttons/leftBtn.png"
                                         selectedImage: @"buttons/leftBtnOn.png"
                                                target: self
                                              selector: @selector(leftBtnCallback)];
        menu = [CCMenu menuWithItems: leftBtn, nil];
        menu.position = ccp(8.0f + leftBtn.contentSize.width/2, kScreenCenterY);
        leftBtn.position = ccp(0, 0);
        leftBtn.scale = 0.8f;
        leftBtn.opacity = 0;
        leftBtn.isEnabled = NO;
        [self addChild: menu z: 0];
        
        // skip btn
        skipBtn = [CCMenuItemImage itemFromNormalImage: @"buttons/exitBtn.png"
                                         selectedImage: @"buttons/exitBtn.png"
                                                target: self
                                              selector: @selector(skipBtnCallback)];
        skipBtn.anchorPoint = ccp(1, 0);
        skipBtn.scale = 0.7f;
        menu = [CCMenu menuWithItems: skipBtn, nil];
        menu.position = ccp(kScreenWidth - 8.0f, 8.0f);
        [self addChild: menu];
        
        // pages
        pagesLayer = [CCLayer node];
        [self addChild: pagesLayer];
        
        CCLayer *page;
        float pageShift = 0;
        
        if([pages containsObject: kGhostsTutorial])
        {
            page = [self ghostsPage];
            page.position = ccp(pageShift, 0);
            pageShift += kScreenWidth;
            [pagesLayer addChild: page];
        }
        
        if([pages containsObject: kBombTutorial])
        {
            page = [self bombPage];
            page.position = ccp(pageShift, 0);
            pageShift += kScreenWidth;
            [pagesLayer addChild: page];
        }
        
        if([pages containsObject: kShieldTutorial])
        {
            page = [self shieldPage];
            page.position = ccp(pageShift, 0);
            pageShift += kScreenWidth;
            [pagesLayer addChild: page];
        }
        
        if([pages containsObject: kBonusTutorial])
        {
            page = [self bonusPage];
            page.position = ccp(pageShift, 0);
            pageShift += kScreenWidth;
            [pagesLayer addChild: page];
        }
        
        if([pages containsObject: kTimeBonusTutorial])
        {
            page = [self timeBonusPage];
            page.position = ccp(pageShift, 0);
            pageShift += kScreenWidth;
            [pagesLayer addChild: page];
        }
        
        if([pages count] == 1)
        {
            rightBtn.opacity = 0;
            rightBtn.isEnabled = NO;
        }
        
        currentPageNumber = 0;
    }
    
    return self;
}

- (CCLayer *) ghostsPage
{
    static const unsigned ghostsNumber = 5;
    
    CCNode *ghosts = [CCNode node];
    
    for(int i = 0; i < ghostsNumber; i++)
    {
        CCSprite *ghost = [CCSprite node];
        ghost.anchorPoint = ccp(0.5, 0);
        ghost.position = ccp((2 - i)*70.0f, 0);
        NSString *animationName = [NSString stringWithFormat: @"zombieMoving%i", i];
        CCAnimate *movingAnimation = [CCAnimate actionWithAnimation: 
                                                        [[CCAnimationCache sharedAnimationCache] animationByName: animationName]
                                              restoreOriginalFrame: NO];
        [ghost runAction:
                    [CCRepeatForever actionWithAction: movingAnimation]
        ];
        
        [ghosts addChild: ghost];
    }
    
    NSString *description = @"this is|a multiline|description";
    
    return [self pageWithPicture: ghosts andDescription: description];
}

- (CCLayer *) bombPage
{
    CCSprite *sprite = [CCSprite node];
    sprite.anchorPoint = ccp(0.5, 0);
    NSString *animationName = [NSString stringWithFormat: @"zombieMoving%i", 5];
    CCAnimate *movingAnimation = [CCAnimate actionWithAnimation: 
                                                    [[CCAnimationCache sharedAnimationCache] animationByName: animationName]
                                          restoreOriginalFrame: NO];
    [sprite runAction:
                [CCRepeatForever actionWithAction: movingAnimation]
    ];
    
    CCNode *pic = [CCNode node];
    [pic addChild: sprite];
    
    NSString *description = @"this is|a multiline|description";
    
    return [self bonusPageWithPicture: pic andDescription: description];
}

- (CCLayer *) shieldPage
{
    CCSprite *sprite = [CCSprite node];
    sprite.anchorPoint = ccp(0.5, 0);
    NSString *animationName = [NSString stringWithFormat: @"zombieMoving%i", 6];
    CCAnimate *movingAnimation = [CCAnimate actionWithAnimation: 
                                                    [[CCAnimationCache sharedAnimationCache] animationByName: animationName]
                                          restoreOriginalFrame: NO];
    [sprite runAction:
                [CCRepeatForever actionWithAction: movingAnimation]
    ];
    
    CCNode *pic = [CCNode node];
    [pic addChild: sprite];
    
    NSString *description = @"this is|a multiline|description";
    
    return [self bonusPageWithPicture: pic andDescription: description];
}

- (CCLayer *) bonusPage
{
    CCSprite *sprite = [CCSprite node];
    sprite.anchorPoint = ccp(0.5, 0);
    NSString *animationName = [NSString stringWithFormat: @"zombieMoving%i", 7];
    CCAnimate *movingAnimation = [CCAnimate actionWithAnimation: 
                                                    [[CCAnimationCache sharedAnimationCache] animationByName: animationName]
                                          restoreOriginalFrame: NO];
    [sprite runAction:
                [CCRepeatForever actionWithAction: movingAnimation]
    ];
    
    CCNode *pic = [CCNode node];
    [pic addChild: sprite];
    
    NSString *description = @"this is|a multiline|description";
    
    return [self bonusPageWithPicture: pic andDescription: description];
}

- (CCLayer *) timeBonusPage
{
    CCSprite *sprite = [CCSprite node];
    sprite.anchorPoint = ccp(0.5, 0);
    NSString *animationName = [NSString stringWithFormat: @"zombieMoving%i", 8];
    CCAnimate *movingAnimation = [CCAnimate actionWithAnimation: 
                                                    [[CCAnimationCache sharedAnimationCache] animationByName: animationName]
                                          restoreOriginalFrame: NO];
    [sprite runAction:
                [CCRepeatForever actionWithAction: movingAnimation]
    ];
    
    CCNode *pic = [CCNode node];
    [pic addChild: sprite];
    
    NSString *description = @"this is|a multiline|description";
    
    return [self bonusPageWithPicture: pic andDescription: description];
}

- (CCLayer *) bonusPageWithPicture: (CCNode *) pic andDescription: (NSString *) desc
{
    pic.anchorPoint = ccp(0.5, 0);
    [pic runAction:
                [CCRepeatForever actionWithAction:
                                    [CCSequence actions:
                                                    [CCScaleTo actionWithDuration: 0.25f scaleX: 0.95f scaleY: 1.05f],
                                                    [CCScaleBy actionWithDuration: 0.25f scaleX: 1.05f scaleY: 0.95f],
                                                    nil
                                    ]
                ]
    ];
    
    return [self pageWithPicture: pic andDescription: desc];
}

- (CCLayer *) pageWithPicture: (CCNode *) pic andDescription: (NSString *) desc_
{
    CCLayer *page = [CCLayer node];

    pic.anchorPoint = ccp(0.5f, 0);
    pic.position = ccp(kScreenCenterX, kScreenCenterY - 32.0f);
    [page addChild: pic z: 0 tag: kPicTag];
    
    CCMenu *desc = [CCMenu menuWithItems: nil];
    NSArray *descLines = [desc_ componentsSeparatedByString: @"|"];
    for(NSString *descLine in descLines)
    {
        CCMenuItemLabel *line = [CCMenuItemLabel itemWithLabel: [CCLabelBMFont labelWithString: descLine fntFile: kFontDefault]];
        [desc addChild: line];
    }
    [desc alignItemsVerticallyWithPadding: -8.0f];
    desc.position = ccp(kScreenCenterX, kScreenHeight*2/5 - 48.0f);
    desc.isTouchEnabled = NO;
    [page addChild: desc z: 0];
    
    return page;
}

+ (id) popupWithDelegate: (id<CCPopupLayerDelegate>) delegate pages: (NSArray *) pages
{
    return [[[self alloc] initWithDelegate: delegate pages: pages] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (void) hideAndClose
{
    [self disableWithChildren];
    
    [background runAction:
                    [CCSequence actions:
                                    [CCFadeTo actionWithDuration: 0.4f opacity: 0],
                                    [CCCallFunc actionWithTarget: self selector: @selector(removeFromParentWithCleanup)],
                                    nil
                    ]
    ];
    
    [pagesLayer runAction:
                    [CCSequence actions:
                                    [CCEaseBackIn actionWithAction:
                                                        [CCMoveBy actionWithDuration: 0.3f 
                                                                            position: ccp(0, kScreenHeight)]
                                    ],
                                    nil
                    ]
    ];
    
    [rightBtn runAction: [CCFadeTo actionWithDuration: 0.2f opacity: 0]];
    [leftBtn runAction: [CCFadeTo actionWithDuration: 0.2f opacity: 0]];
    [skipBtn runAction: [CCFadeTo actionWithDuration: 0.2f opacity: 0]];
}

#pragma mark -

#pragma mark callbacks
- (void) rightBtnCallback
{
    int maxPageNumber = [[pagesLayer children] count] - 1;
    
    currentPageNumber++;
    currentPageNumber = currentPageNumber > maxPageNumber ? maxPageNumber : currentPageNumber;
    
    [pagesLayer runAction:
                    [CCEaseBackOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.3f position: ccp(-kScreenWidth*currentPageNumber, 0)]
                    ]
     ];
    
    if(currentPageNumber == maxPageNumber)
    {
        rightBtn.isEnabled = NO;
        
        [rightBtn runAction: [CCFadeOut actionWithDuration: 0.2f]];
    }
    
    if(currentPageNumber == 1)
    {
        leftBtn.isEnabled = YES;
        
        [leftBtn runAction: [CCFadeIn actionWithDuration: 0.2f]];
    }
}

- (void) leftBtnCallback
{
    int maxPageNumber = [[pagesLayer children] count] - 1;
    currentPageNumber--;
    currentPageNumber = currentPageNumber < 0 ? 0 : currentPageNumber;
    
    [pagesLayer runAction:
                    [CCEaseBackOut actionWithAction:
                                        [CCMoveTo actionWithDuration: 0.3f position: ccp(-kScreenWidth*currentPageNumber, 0)]
                    ]
    ];
    
    if(currentPageNumber == 0)
    {
        leftBtn.isEnabled = NO;
        
        [leftBtn runAction: [CCFadeOut actionWithDuration: 0.2f]];
    }
    
    if(currentPageNumber == maxPageNumber - 1)
    {
        rightBtn.isEnabled = YES;
        
        [rightBtn runAction: [CCFadeIn actionWithDuration: 0.2f]];
    }
}

- (void) skipBtnCallback
{
    [self hideAndClose];
}

#pragma mark -


@end
