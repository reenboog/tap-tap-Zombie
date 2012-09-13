//
//  HUD.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"
#import "GamePausePopup.h"

#import "GameConfig.h"

#import "Game.h"


@interface HUD()
- (void) setValueForProgressScale: (float) value;
@end

@implementation HUD

@synthesize delegate;

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        CCMenu *menu;
        CCLabelBMFont *label;
        
        // pause btn
        label = [CCLabelBMFont labelWithString: @"pause" fntFile: kDefaultGameFont];
        pauseBtn = [CCMenuItemLabel itemWithLabel: label
                                           target: self
                                         selector: @selector(pauseBtnCallback)];
        
        menu = [CCMenu menuWithItems: pauseBtn, nil];
        menu.position = ccp(8.0f + pauseBtn.contentSize.width/2, kScreenHeight - 8.0f - pauseBtn.contentSize.height/2);
        [self addChild: menu];
        
        // progress scale
        progressScale = [CCProgressTimer progressWithFile: @"HUD/damageScaleInner.png"];
        progressScale.type = kCCProgressTimerTypeHorizontalBarLR;
        progressScale.position = ccp(kScreenCenterX, 16.0f);
        [self setValueForProgressScale: 0];
        [self addChild: progressScale];
        
        // additional
        movingTimeLabel = [CCLabelTTF labelWithString: @"" fontName: @"Arial" fontSize: 16];
        movingTimeLabel.anchorPoint = ccp(1, 1);
        movingTimeLabel.position = ccp(kScreenWidth - 8.0f, kScreenHeight - 8.0f);
        [self addChild: movingTimeLabel];
        
        standingTimeLabel = [CCLabelTTF labelWithString: @"" fontName: @"Arial" fontSize: 16];
        standingTimeLabel.anchorPoint = ccp(1, 1);
        standingTimeLabel.position = ccp(kScreenWidth - 8.0f, kScreenHeight - 32.0f);
        [self addChild: standingTimeLabel];
        
        perfectWaysLabel = [CCLabelTTF labelWithString: @"" fontName: @"Arial" fontSize: 16];
        perfectWaysLabel.anchorPoint = ccp(1, 1);
        perfectWaysLabel.position = ccp(kScreenWidth - 8.0f, kScreenHeight - 56.0f);
        [self addChild: perfectWaysLabel];
    }
    
    return self;
}

+ (id) hud
{
    return [[[self alloc] init]  autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark progress scale
- (void) setValueForProgressScale: (float) value
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

#pragma mark CCPopupLayerDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [delegate pause];
    
    [self pauseSchedulerAndActions];
    [self disableWithChildren];
}

- (void) popupDidFinishClosing:(CCPopupLayer *)popup
{
    [delegate resume];
    
    [self resumeSchedulerAndActionsWithChildren];
    [self enableWithChildren];
}

- (void) reset
{
    [delegate reset];
}

#pragma mark -

#pragma mark callbacks
- (void) pauseBtnCallback
{
    [GamePausePopup showOnRunningSceneWithDelegate: self];
}

#pragma mark -

#pragma mark additional
- (void) updateMovingTime: (float) t min: (float) mint max: (float) maxt
{
    [movingTimeLabel setString: [NSString stringWithFormat: @"%.2f/(%.1f, %.1f)", t, mint, maxt]];
}

- (void) updateStandingTime: (float) t min: (float) mint max: (float) maxt
{
    [standingTimeLabel setString: [NSString stringWithFormat: @"%.2f/(%.1f, %.1f)", t, mint, maxt]];
}

- (void) updatePerfectWays: (int) pw
{
    [perfectWaysLabel setString: [NSString stringWithFormat: @"%i", pw]];
    CCLOG(@"%i", pw);
}

@end
