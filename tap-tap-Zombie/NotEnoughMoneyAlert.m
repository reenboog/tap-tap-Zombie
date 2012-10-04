//
//  NotEnoughMoneyAlert.m
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NotEnoughMoneyAlert.h"

#import "GameConfig.h"


#define kWidth 320.0f
#define kHeight 80.0f
#define kShownPosition ccp(kScreenCenterX, kScreenHeight)
#define kHiddenPosition ccp(kScreenCenterX, kScreenHeight + kHeight)
#define kDelayTime 2.0f

@implementation NotEnoughMoneyAlert

@synthesize isShown;

#pragma mark init and dealloc
- (id) init
{
    if(self = [super initWithColor: ccc4(100, 100, 100, 200)])
    {
        [self setContentSize: CGSizeMake(kWidth, kHeight)];
        self.isRelativeAnchorPoint = YES;
        self.anchorPoint = ccp(0.5f, 1);
        self.position = kHiddenPosition;
        opacity_ = 0;
        
        label = [CCLabelBMFont labelWithString: @"You have not enough money" fntFile: kFontDefault];
        label.position = ccp(kWidth/2, kHeight/2);
        label.opacity = 0;
        [self addChild: label];
        
        
        isShown = NO;
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (void) stopAllActions
{
    [super stopAllActions];
    
    [label stopAllActions];
}

- (void) hide
{
    if(!isShown) return; 
    
    [self stopAllActions];
    
    [self runAction:
                [CCSequence actions:
                                [CCSpawn actions:
                                            [CCMoveTo actionWithDuration: 0.3f position: kHiddenPosition],
                                            [CCFadeTo actionWithDuration: 0.3f opacity: 0],
                                            nil
                                ],
                                [CCCallBlock actionWithBlock: ^(void) {isShown = NO;}],
                                nil
                ]
    ];
    
    [label runAction: [CCFadeTo actionWithDuration: 0.25f opacity: 0]];
}

- (void) show
{
    if(isShown) return;
    
    isShown = YES;
    
    [self stopAllActions];
    
    [self runAction: 
                [CCSequence actions:
                                [CCSpawn actions:
                                            [CCMoveTo actionWithDuration: 0.3f position: kShownPosition],
                                            [CCFadeTo actionWithDuration: 0.2f opacity: 200],
                                            nil
                                ],
                                [CCDelayTime actionWithDuration: kDelayTime],
                                [CCCallFunc actionWithTarget: self selector: @selector(hide)],
                                nil
                ]
    ];
    
    [label runAction: [CCFadeTo actionWithDuration: 0.2f opacity: 255]];
}

@end
