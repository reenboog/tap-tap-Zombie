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

- (void) runWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t;
- (void) stand;
- (void) disappearBad;
- (void) disappearGood;

@end


@implementation GameItem

#pragma mark init and dealloc
- (id) initWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t
{
    if(self = [super init])
    {
        sprite = [CCSprite spriteWithFile: @"Icon-Small.png"];
        [self addChild: sprite];
        [self setContentSize: CGSizeMake(sprite.contentSize.width, sprite.contentSize.height)];
        
        [self reset];
        
        [self runWithStartPosition: sp endPosition: ep time: t];
    }
    
    return self;
}

+ (id) gameItemWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t
{
    return [[[self alloc] initWithStartPosition: sp endPosition: ep time: t] autorelease];
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
}

- (void) stop
{
    [self stopAllActions];
    [sprite stopAllActions];
}

#pragma mark -

#pragma mark states
- (void) runWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t
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
                                                                [CCBezierTo actionWithDuration: t
                                                                                        bezier: bezierConfig],
//                                            ],
                                            nil
                                ],
                                [CCCallFunc actionWithTarget: self selector: @selector(stand)],
                                nil
                ]
    ];
    
    [sprite runAction:
                [CCSpawn actions:
                                [CCFadeIn actionWithDuration: 0.3f],
                                [CCScaleTo actionWithDuration: t scale: 1.0f],
                                nil
                ]
    ];
}

- (void) stand
{
    [self stopAllActions];
    [sprite stopAllActions];
    
    state = gis_standing;
    
    [sprite runAction:
                [CCSequence actions:
                                [CCTintTo actionWithDuration: 1.0f red: 255 green: 0 blue: 0],
                                [CCCallFunc actionWithTarget: self selector: @selector(disappearBad)],
                                nil
                ]
    ];
}

- (void) disappearBad
{
    [self stopAllActions];
    [sprite stopAllActions];
    
    state = gis_disappearing;
    
    float scale = sprite.scale + 0.2f;
    
    [sprite runAction:
                [CCSequence actions:
                                [CCSpawn actions:
                                            [CCTintTo actionWithDuration: 0.2f red: 255 green: 0 blue: 0],
                                            [CCScaleTo actionWithDuration: 0.5f scale: scale],
                                            [CCFadeOut actionWithDuration: 0.5f],
                                            nil
                                ],
                                [CCCallFunc actionWithTarget: self selector: @selector(removeFromParentWithCleanup)],
                                nil
                ]
    ];
}

- (void) disappearGood
{
    [self stopAllActions];
    [sprite stopAllActions];
    
    state = gis_disappearing;
    
    [sprite runAction:
                [CCSequence actions:
                                [CCSpawn actions:
                                            [CCTintTo actionWithDuration: 0.2f red: 0 green: 255 blue: 0],
                                            [CCScaleTo actionWithDuration: 0.5f scale: 1.2f],
                                            [CCFadeOut actionWithDuration: 0.5f],
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
            case gis_disappearing:
            case gis_none: break;
                
            case gis_moving:
            {
                [self disappearBad];
            } break;
                
            case gis_standing:
            {
                [self disappearGood];
            } break;
        }
    }
}

@end