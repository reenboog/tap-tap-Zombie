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

#import "Trap.h"


#define kPicTag 11

@interface TutorialPopup ()
- (CCLayer *) pageWithPicture: (CCNode *) pic andDescription: (NSString *) desc;
- (CCLayer *) bonusPageWithPicture: (CCNode *) pic andDescription: (NSString *) desc;

- (CCLayer *) ghostsPage;
- (CCLayer *) trapPage;
- (CCLayer *) progressPage;

- (CCLayer *) bombPage;
- (CCLayer *) superModePage;

- (CCLayer *) jumperPage;

- (CCLayer *) shieldPage;

- (CCLayer *) bonusPage;
- (CCLayer *) shopPage;

- (CCLayer *) timeBonusPage;
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
        menu.position = ccp(kScreenWidth - 8.0f - rightBtn.contentSize.width/2, 8.0f);
        rightBtn.anchorPoint = ccp(0.5f, 0);
        rightBtn.position = ccp(0, 0);
        rightBtn.scale = 0.8f;
        [self addChild: menu z: 0];
        
        leftBtn = [CCMenuItemImage itemFromNormalImage: @"buttons/leftBtn.png"
                                         selectedImage: @"buttons/leftBtnOn.png"
                                                target: self
                                              selector: @selector(leftBtnCallback)];
        menu = [CCMenu menuWithItems: leftBtn, nil];
        menu.position = ccp(8.0f + leftBtn.contentSize.width/2, 8.0f);
        leftBtn.anchorPoint = ccp(0.5f, 0);
        leftBtn.position = ccp(0, 0);
        leftBtn.scale = 0.8f;
        leftBtn.opacity = 0;
        leftBtn.isEnabled = NO;
        [self addChild: menu z: 0];
        
        // skip btn
        CCLabelBMFont *btnLabel = [CCLabelBMFont labelWithString: @"skip" fntFile: kFontDefault];
        btnLabel.color = ccc3(180, 180, 180);
        skipBtn = [CCMenuItemLabel itemWithLabel: btnLabel 
                                          target: self
                                        selector: @selector(skipBtnCallback)];
        skipBtn.anchorPoint = ccp(1, 0);
        skipBtn.scale = 0.9f;
        menu = [CCMenu menuWithItems: skipBtn, nil];
        menu.position = ccp(kScreenCenterX, 8.0f);
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
        
        if([pages containsObject: kTrapTutorial])
        {
            page = [self trapPage];
            page.position = ccp(pageShift, 0);
            pageShift += kScreenWidth;
            [pagesLayer addChild: page];
        }
        
        if([pages containsObject: kProgressTutorial])
        {
            page = [self progressPage];
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
        
        if([pages containsObject: kSuperModeTutorial])
        {
            page = [self superModePage];
            page.position = ccp(pageShift, 0);
            pageShift += kScreenWidth;
            [pagesLayer addChild: page];
        }
        
        if([pages containsObject: kJumperTutorial])
        {
            page = [self jumperPage];
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
        
        if([pages containsObject: kShopTutorial])
        {
            page = [self shopPage];
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
        
        if([pages count] < 2)
        {
            [(CCMenuItemLabel *)skipBtn setString: @"close"];
        }
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
    
    NSString *description = @"These deadly zombie ghosts|are trying to get your brains.";
    
    return [self pageWithPicture: ghosts andDescription: description];
}

- (CCLayer *) trapPage
{
    CCNode *zombieInTrap = [CCNode node];
    
    CCSprite *backLight = [CCSprite spriteWithFile: @"levels/traps/0/back_light.png"];
    backLight.anchorPoint = ccp(0.5f, 0);
    backLight.color = ccc3(0, 255, 0);
    [zombieInTrap addChild: backLight];
    
    CCSprite *gate = [CCSprite node];
    gate.anchorPoint = ccp(0.5f, 0);
    [zombieInTrap addChild: gate];
    [gate runAction: 
                [CCAnimate actionWithAnimation: [[CCAnimationCache sharedAnimationCache] animationByName: @"gate0"]
                           restoreOriginalFrame: NO
                ]
    ];
    
    CCSprite *body = [CCSprite spriteWithFile: @"levels/traps/0/body.png"];
    body.anchorPoint = ccp(0.5f, 0);
    [zombieInTrap addChild: body];
    
    CCSprite *zombie = [CCSprite spriteWithSpriteFrameName: @"zombieMoving00.png"];
    zombie.anchorPoint = ccp(0.5f, 0);
    zombie.position = ccp(0, 30);
    zombie.scale = 0.8f;
    [zombieInTrap addChild: zombie];
    
    CCSprite *light = [CCSprite spriteWithFile: @"levels/traps/0/light.png"];
    light.anchorPoint = ccp(0.5f, 0);
    light.color = ccc3(0, 255, 0);
    [zombieInTrap addChild: light];
    
    NSString *description = @"Use this secret weapon for defence.";
    
    return [self pageWithPicture: zombieInTrap andDescription: description];
}

- (CCLayer *) progressPage
{
    CCNode *node = [CCNode node];
    [node setContentSize: CGSizeMake(0, 100)];
    
    CCSprite *progressScaleWrapper = [CCSprite spriteWithFile: @"HUD/damageScaleOuter.png"];
    progressScaleWrapper.anchorPoint = ccp(0.5f, 0.5f);
    progressScaleWrapper.position = ccp(0, 100);
    progressScaleWrapper.scaleX = 0.8f;
    [node addChild: progressScaleWrapper];
    
    CCProgressTimer *progressScale = [CCProgressTimer progressWithFile: @"HUD/damageScaleInner.png"];
    progressScale.type = kCCProgressTimerTypeHorizontalBarLR;
    float w = progressScaleWrapper.contentSize.width;
    float h = progressScaleWrapper.contentSize.height;
    progressScale.position = ccp(w/2, h/2);
    progressScale.percentage = 50;
    [progressScaleWrapper addChild: progressScale];
    
    NSString *description = @"Catch required amount of zomboghosts|to pass the level.";
    
    return [self pageWithPicture: node andDescription: description];
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
    
    NSString *description = @"Do not touch any bombs!";
    
    return [self bonusPageWithPicture: pic andDescription: description];
}

- (CCLayer *) superModePage
{
    CCNode *node = [CCNode node];
    [node setContentSize: CGSizeMake(0, 100)];
    
    CCSprite *progressScaleWrapper = [CCSprite spriteWithFile: @"HUD/damageScaleOuter.png"];
    progressScaleWrapper.anchorPoint = ccp(0.5f, 0.5f);
    progressScaleWrapper.position = ccp(0, 100);
    progressScaleWrapper.scaleX = 0.8f;
    [node addChild: progressScaleWrapper];
    
    CCProgressTimer *progressScale = [CCProgressTimer progressWithFile: @"HUD/damageScaleInner.png"];
    progressScale.type = kCCProgressTimerTypeHorizontalBarLR;
    float w = progressScaleWrapper.contentSize.width;
    float h = progressScaleWrapper.contentSize.height;
    progressScale.position = ccp(w/2, h/2);
    progressScale.percentage = 75;
    [progressScaleWrapper addChild: progressScale];
    
    CCLabelBMFont *label = [CCLabelBMFont labelWithString: @"Supermode-3" fntFile:kFontDefault];
    label.color = ccc3(255, 0, 0);
    label.position = ccp(0, 70);
    [node addChild: label];
    
    NSString *description = @"Enter supermodes|with accurate taps to progress faster.";
    
    return [self pageWithPicture: node andDescription: description];
}

- (CCLayer *) jumperPage
{
    CCNode *roads = [CCSprite spriteWithFile: @"tutorial/roads.png"];
    
    CCSprite *zombie = [CCSprite node];
    [zombie runAction: [CCRepeatForever actionWithAction:
                [CCAnimate actionWithAnimation: [[CCAnimationCache sharedAnimationCache] animationByName: @"zombieMoving3"]
                           restoreOriginalFrame: NO
                ]]
    ];
    zombie.anchorPoint = ccp(0.5f, 0);
    zombie.position = ccp(40, 30);
    
    [zombie runAction:
                [CCRepeatForever actionWithAction:
                                    [CCSequence actions:
                                                    [CCDelayTime actionWithDuration: 2.0f],
                                                    [CCMoveBy actionWithDuration: 0.3f position: ccp(110, 0)],
                                                    [CCDelayTime actionWithDuration: 2.0f],
                                                    [CCMoveBy actionWithDuration: 0.3f position: ccp(-110, 0)],
                                                    nil
                                    ]
                ]
    ];
    
    [roads addChild: zombie];
    
    NSString *description = @"Beware of jumpers:|they can change their direction.";
    
    return [self pageWithPicture: roads andDescription: description];
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
    
    NSString *description = @"The Shield automatically catches|all zombies for a limited time.";
    
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
    
    NSString *description = @"Collect bonuses and earn zombo bucks.";
    
    return [self bonusPageWithPicture: pic andDescription: description];
}

- (CCLayer *) shopPage
{
    CCNode *node = [CCNode node];
    CCSprite *shop = [CCSprite spriteWithFile: @"tutorial/shop.png"];
    shop.position = ccp(0, 50);
    [node addChild: shop];
    
    NSString *description = @"Purchase items from zombo store|to become the ultimate survivor!";
    
    return [self bonusPageWithPicture: node andDescription: description];
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
        [(CCMenuItemLabel *)skipBtn setString: @"close"];
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
        
        [(CCMenuItemLabel *)skipBtn setString: @"skip"];
    }
}

- (void) skipBtnCallback
{
    [self hideAndClose];
}

#pragma mark -


@end
