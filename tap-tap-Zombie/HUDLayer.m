//
//  HUDLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "HUDLayer.h"


@implementation HUDLayer

#pragma mark init and dealloc
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
        
        // progress scale
        CCSprite *progressScaleWrapper = [CCSprite spriteWithFile: @"HUD/damageScaleOuter.png"];
        progressScaleWrapper.position = ccp(kScreenCenterX, kScreenHeight - 8.0f - progressScaleWrapper.contentSize.height/2);
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

#pragma mark progress scale
- (void) setProgressScaleValue: (float) value
{
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

#pragma mark -

#pragma mark callbacks
- (void) pauseBtnCallback
{
    [delegate pause];
}

#pragma mark -

@end
