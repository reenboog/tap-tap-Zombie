//
//  GameItem.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameItem.h"
#import "GameConfig.h"


@interface GameItem()

- (void) reset;

- (void) standWithTime: (NSNumber *) st;
- (void) disappear;

@end


@implementation GameItem

@synthesize wave;
@synthesize index;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GameItemLogicDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        sprite = [CCSprite spriteWithFile: @"Icon-Small.png"];
        [self addChild: sprite];
        [self setContentSize: CGSizeMake(sprite.contentSize.width, sprite.contentSize.height)];
        
        [self reset];
    }
    
    return self;
}

+ (id) gameItemWithDelegate: (id<GameItemLogicDelegate>) delegate
{
    return [[[GameItem alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark reset
- (void) reset
{
    state = gis_none;
    isCatched = NO;
}

- (void) stop
{
    [self stopAllActions];
    [sprite stopAllActions];
}

#pragma mark -

#pragma mark states
- (void) runWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep movingTime: (ccTime) mt standingTime: (ccTime) st
{
    [self stopAllActions];
    [sprite stopAllActions];
    
    state = gis_moving;
    
    ccBezierConfig bezierConfig = {ccp(ep.x, ep.y), ccp(sp.x, kScreenCenterY), ccp(ep.x, kScreenCenterY)};
    
    self.position = ccp(sp.x, sp.y);
    
    sprite.scale = 0.2f;
    sprite.opacity = 0;
    
    [self runAction:
                [CCSequence actions:
                                [CCSpawn actions:
//                                            [CCEaseSineOut actionWithAction:
                                                                [CCBezierTo actionWithDuration: mt
                                                                                        bezier: bezierConfig],
//                                            ],
                                            nil
                                ],
                                [CCCallFuncO actionWithTarget: self 
                                                     selector: @selector(standWithTime:)
                                                       object: [NSNumber numberWithInt: st]],
                                nil
                ]
    ];
    
    [sprite runAction:
                [CCSpawn actions:
                                [CCFadeIn actionWithDuration: 0.3f],
                                [CCScaleTo actionWithDuration: mt scale: 1.0f],
                                nil
                ]
    ];
}

- (void) standWithTime: (NSNumber *) st
{
    int standingTime = [st intValue];
    
    [self stopAllActions];
    [sprite stopAllActions];
    
    state = gis_standing;
    
    [sprite runAction:
                [CCSequence actions:
                                [CCTintTo actionWithDuration: standingTime red: 0 green: 0 blue: 255],
                                [CCCallFunc actionWithTarget: self selector: @selector(disappear)],
                                nil
                ]
    ];
}

- (void) disappear
{
    [self stopAllActions];
    [sprite stopAllActions];
    
    [delegate gameItemDisappears: self];
    
    ccColor3B c = ((state == gis_standing) && isCatched) ? ccc3(0, 255, 0) : ccc3(255, 0, 0);
    
    state = gis_disappearing;
    
    float scale = sprite.scale + 0.2f;
    
    [sprite runAction:
                [CCSequence actions:
                                [CCSpawn actions:
                                            [CCTintTo actionWithDuration: 0.2f red: c.r green: c.g blue: c.b],
                                            [CCScaleTo actionWithDuration: 0.3f scale: scale],
                                            [CCFadeOut actionWithDuration: 0.3f],
                                            nil
                                ],
                                [CCCallFunc actionWithTarget: self selector: @selector(removeFromParentWithCleanup)],
                                nil
                ]
    ];
}

- (void) tap: (UITouch *) touch
{
    if([sprite touchInNode: touch])
    {
        switch(state)
        {
            case gis_moving: break;
                
            case gis_standing:
            {
                isCatched = YES;
            } break;
                
            default: return;
        }
        
        [self disappear];
    }
}

#pragma mark -

#pragma mark LogicGameItemDelegate methods implementation
- (BOOL) isMissing
{
    return ((state != gis_standing) || !isCatched);
}


@end