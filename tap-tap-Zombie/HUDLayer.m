//
//  HUDLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "Shop.h"

#import "HUDLayer.h"


#define kBombAbilityBtn         kSuperblast
#define kBombAbilityBtnTag      11
#define kShieldAbilityBtn       kShield
#define kShieldAbilityBtnTag    12
#define kRandomAbilityBtn       kGreatLottery
#define kRandomAbilityBtnTag    13
#define kTimeAbilityBtn         kTimeCheater
#define kTimeAbilityBtnTag      14

#define kAmountTag 21

// return string with format "mm:ss"
static NSString* ccTimeToString(ccTime time)
{
    int t = (int)time;
    int h = t/3600;
    int m = (t - h*3600)/60;
    int s = t - h*3600 - m*60;
    
    return [NSString stringWithFormat: @"%.2d:%.2d", m, s];
}

@implementation HUDLayer

#pragma mark init and dealloc
- (void) initAbilitiesMenu
{
    static NSString *abilities[4] = { kSuperblast, kShield, kGreatLottery, kTimeCheater };
    static const int abilityTags[4] = { kBombAbilityBtnTag, kShieldAbilityBtnTag, kRandomAbilityBtnTag, kTimeAbilityBtnTag };
    
    CCSprite *buttonSrites[4][2] = {
        {[CCSprite spriteWithSpriteFrameName: @"bombBtn.png"], [CCSprite spriteWithSpriteFrameName: @"bombBtnOn.png"]},
        {[CCSprite spriteWithSpriteFrameName: @"shieldBtn.png"], [CCSprite spriteWithSpriteFrameName: @"shieldBtnOn.png"]},
        {[CCSprite spriteWithSpriteFrameName: @"randomBtn.png"], [CCSprite spriteWithSpriteFrameName: @"randomBtnOn.png"]},
        {[CCSprite spriteWithSpriteFrameName: @"timeBtn.png"], [CCSprite spriteWithSpriteFrameName: @"timeBtnOn.png"]}
    };
    
    abilitiesMenu = [CCMenu menuWithItems: nil];
    for(int i = 0; i < 4; i++)
    {
        if([abilities[i] isEqualToString: kTimeCheater] && !delegate.isArcadeGame)
        {
            continue;
        }
        
        ShopItem *shopItem = [[Shop sharedShop] itemWithName: abilities[i]];
        
        if([shopItem amount] < 1)
        {
            continue;
        }
        
        CCMenuItemSprite *item = [CCMenuItemSprite itemFromNormalSprite: buttonSrites[i][0]
                                                         selectedSprite: buttonSrites[i][1]
                                                                 target: self
                                                               selector: @selector(abilityBtnCallback:)];
        item.anchorPoint = ccp(0, 0.5f);
        item.tag = abilityTags[i];
        
        CCLabelBMFont *amount = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%i", [shopItem amount]] 
                                                       fntFile: kFontDefault];
        amount.anchorPoint = ccp(0, 0);
        amount.position = ccp(0, 0);
        amount.tag = kAmountTag;
        [item addChild: amount];
        
        [abilitiesMenu addChild: item];
    }
    [abilitiesMenu alignItemsVertically];
    abilitiesMenu.position = ccp(8.0f, kScreenCenterY);
    
    [self addChild: abilitiesMenu];
}

- (id) initWithDelegate: (id<HUDLayerDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        CCMenu *menu;
        CCSprite *btnSprite;
        CCSprite *btnOnSprite;
        
        // pause btn
        float pbs = 0.75f;
        btnSprite = [CCSprite spriteWithFile: @"buttons/pauseBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/pauseBtnOn.png"];
        pauseBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                           selectedSprite: btnOnSprite
                                                   target: self
                                                 selector: @selector(pauseBtnCallback)];
        pauseBtn.scale = pbs;
        
        menu = [CCMenu menuWithItems: pauseBtn, nil];
        menu.position = ccp(8.0f + pauseBtn.contentSize.width/2*pbs, kScreenHeight - 8.0f - pauseBtn.contentSize.height/2*pbs);
        [self addChild: menu];
        
        if(!delegate.isArcadeGame)
        {
        // progress scale
            CCSprite *progressScaleWrapper = [CCSprite spriteWithFile: @"HUD/damageScaleOuter.png"];
            progressScaleWrapper.anchorPoint = ccp(0.5f, 1);
            progressScaleWrapper.position = ccp(kScreenCenterX, kScreenHeight - 8.0f);
            [self addChild: progressScaleWrapper];
            progressScaleWrapper.scaleX = 0.8f;
            
            progressScale = [CCProgressTimer progressWithFile: @"HUD/damageScaleInner.png"];
            progressScale.type = kCCProgressTimerTypeHorizontalBarLR;
            float w = progressScaleWrapper.contentSize.width;
            float h = progressScaleWrapper.contentSize.height;
            progressScale.position = ccp(w/2, h/2);
            [self setProgressScaleValue: 0];
            [progressScaleWrapper addChild: progressScale];
        }
        else
        {
            timerLabel = [CCLabelBMFont labelWithString: @"00:00" fntFile: kFontDefault];
            timerLabel.anchorPoint = ccp(0.5f, 1);
            timerLabel.position = ccp(kScreenCenterX, kScreenHeight - 8.0f);
            [self addChild: timerLabel];
        }
        
        // score label
        scoreLabel = [CCLabelBMFont labelWithString: @"0" fntFile: kFontDefault];
        scoreLabel.anchorPoint = ccp(1, 1);
        scoreLabel.position = ccp(kScreenWidth - 8.0f, kScreenHeight - 8.0f);
        [self addChild: scoreLabel];
        
        // super mode label
        superModeLabel = [CCLabelBMFont labelWithString: @"" fntFile: kFontDefault];
        superModeLabel.position = ccp(kScreenCenterX, kScreenHeight - 48.f);
        [self addChild: superModeLabel];
        
        // abilities
        [self initAbilitiesMenu];
    }
    
    return self;
}

+ (id) hudLayerWithDelegate: (id<HUDLayerDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark reset
- (void) reset
{
    [abilitiesMenu removeFromParentAndCleanup: YES];
    [self initAbilitiesMenu];
}

#pragma mark -

#pragma mark progress scale
- (void) setProgressScaleValue: (float) value
{
    assert(!delegate.isArcadeGame);
    
    float v = value/2 + 50.0f;
    v = v < 0 ? 0 : v > 100 ? 100 : v;
    
    if(progressScale.percentage == v) return;
    
    progressScale.percentage = v;
    
    int d = (int)(255.0f*((100.0f - fabsf(value))/100.0f));
    ccColor3B c = ccc3(255, 255, 255);
    if(v < 50.0f)
    {
        c = ccc3(255, d, d);
    }
    else if(v > 50.0f)
    {
        c = ccc3(d, 255, d);
    }
    
    [progressScale.sprite setColor: ccc3(c.r, c.g, c.b)];
}

- (void) setScoreValue: (float) value
{
    [scoreLabel setString: [NSString stringWithFormat: @"%.0f", value]];
}

#pragma mark -

#pragma mark timer (arcade game mode)
- (void) setTimerValue: (float) timer
{
    assert(delegate.isArcadeGame);
    
    [timerLabel setString: ccTimeToString(timer)];
}

#pragma mark -

#pragma mark callbacks
- (void) pauseBtnCallback
{
    [delegate pause];
}

- (void) abilityBtnCallback: (CCNode *) sender
{
    ShopItem *it = nil;
    
    switch(sender.tag)
    {
        case kBombAbilityBtnTag:
        {
            it = [[Shop sharedShop] itemWithName: kSuperblast];
            [delegate bombAbility];
        } break;
            
        case kShieldAbilityBtnTag:
        {
            it = [[Shop sharedShop] itemWithName: kShield];
            [delegate shieldAbility];
        } break;
            
        case kRandomAbilityBtnTag:
        {
            it = [[Shop sharedShop] itemWithName: kGreatLottery];
            [delegate randomAbility];
        } break;
            
        case kTimeAbilityBtnTag:
        {
            it = [[Shop sharedShop] itemWithName: kTimeCheater];
            [delegate timebBonusAbility];
        } break;
    }
    
    assert(it);
    
    if([it amount] < 1)
    {
        [abilitiesMenu removeChild: sender cleanup: YES];
        [abilitiesMenu alignItemsVertically];
    }
    else
    {
        CCLabelBMFont *amountLabel = (CCLabelBMFont *)[sender getChildByTag: kAmountTag];
        [amountLabel setString: [NSString stringWithFormat: @"%i", [it amount]]];
    }
}

#pragma mark -

- (void) updateSuperModeLabelWithValue: (int) value
{
    [superModeLabel setString: [NSString stringWithFormat: @"super mode %i", value]];
    
    switch(value)
    {
        case 0:
        {
            superModeLabel.color = ccc3(255, 255, 255);
        } break;
            
        case 1:
        {
            superModeLabel.color = ccc3(255, 255, 0);
        } break;
            
        case 2:
        {
            superModeLabel.color = ccc3(0, 255, 0);
        } break;
            
        default: break;
    }
}

- (void) showSuperModeLabel
{
    [superModeLabel stopAllActions];
    
    [superModeLabel runAction: [CCFadeIn actionWithDuration: 0.2f]];
}

- (void) hideSuperModeLabel
{
    [superModeLabel stopAllActions];
    
    [superModeLabel runAction: [CCFadeOut actionWithDuration: 0.2f]];
}

@end
