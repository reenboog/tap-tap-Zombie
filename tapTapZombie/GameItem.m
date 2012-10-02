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

- (void) stand;
- (void) disappear;

@end


@implementation GameItem

@synthesize wave;
@synthesize index;
@synthesize state;
@synthesize award;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GameItemLogicDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        int zombieType = arc4random()%4;
        NSString *filename = [NSString stringWithFormat: @"zombies/zombie%i.png", zombieType];
        sprite = [CCSprite spriteWithFile: filename];
        [self addChild: sprite];
        [self setContentSize: CGSizeMake(sprite.contentSize.width, sprite.contentSize.height)];
        
        if(zombieType != 3)
        {
            award = 1;
        }
        else
        {
            award = -1;
        }
        
        sprite.anchorPoint = ccp(0.5f, 0);
        
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
    [keyPoints release];
    
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
- (void) moveToNextKeyPoint
{
    assert(keyPoints);
    
    if(state == gis_standing) return;
    
    if(++nCurrentKeyPoint < [keyPoints count])
    {
        state = gis_moving;
        
        CGPoint newPosition = [[keyPoints objectAtIndex: nCurrentKeyPoint] CGPointValue];
        
        float fullWayLength = [[keyPoints objectAtIndex: 0] CGPointValue].y - [[keyPoints lastObject] CGPointValue].y;
        float stepLength = self.position.y - newPosition.y;
        
        float p = stepLength/fullWayLength;
        
        [self runAction:
                    [CCSequence actions:
                                    [CCMoveTo actionWithDuration: movingTime*p position: newPosition],
                                    [CCCallFunc actionWithTarget: self selector: @selector(moveToNextKeyPoint)],
                                    nil
                    ]
        ];
    
        return;
    }
    
    [self stand];
}

- (void) runWithKeyPoints: (NSArray *) keyPoints_  movingTime: (ccTime) mt standingTime: (ccTime) st
{
    if(state != gis_none) return;
    
    keyPoints = [keyPoints_ retain];
    nCurrentKeyPoint = 0;
    self.position = [[keyPoints objectAtIndex: 0] CGPointValue];
    movingTime = mt;
    standingTime = st;
    
    [self stopAllActions];
    [sprite stopAllActions];
    
    sprite.scale = 0.2f;
    sprite.opacity = 0;
    
    [sprite runAction: [CCFadeIn actionWithDuration: 0.3f]];
    [sprite runAction: [CCEaseSineIn actionWithAction: [CCScaleTo actionWithDuration: movingTime scale: 0.8f]]];
    
    [self moveToNextKeyPoint];
}

- (void) stand
{
    [self stopAllActions];
    [sprite stopAllActions];
    
    [delegate gameItemStands: self];
    
    state = gis_standing;
    
    [sprite runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: standingTime],
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
    
    float scale = sprite.scale + 0.2f;
    
    if((state == gis_standing) && isCatched)
    {
        [sprite runAction:
                [CCSequence actions:
                                [CCSpawn actions:
                                            [CCScaleTo actionWithDuration: 0.2f scale: scale],
                                            [CCFadeOut actionWithDuration: 0.2f],
                                            nil
                                ],
                                [CCCallFunc actionWithTarget: self selector: @selector(removeFromParentWithCleanup)],
                                nil
                ]
        ];
    }
    else if(state == gis_standing)
    {
        [self runAction:
                    [CCSequence actions:
                                    [CCSpawn actions:
                                                [CCScaleTo actionWithDuration: 0.2f scale: scale],
                                                [CCMoveBy actionWithDuration: 0.3f position: ccp(0, -150.0f)], 
                                                nil
                                    ], 
                                    [CCCallFunc actionWithTarget: self selector: @selector(removeFromParentWithCleanup)],
                                    nil
                    ]
        ];
    }
    else
    {
        [sprite runAction:
                [CCSequence actions:
                                [CCSpawn actions:
                                            [CCTintTo actionWithDuration: 0.2f red: 255 green: 0 blue: 0],
                                            [CCScaleTo actionWithDuration: 0.2f scale: scale],
                                            [CCFadeOut actionWithDuration: 0.2f],
                                            nil
                                ],
                                [CCCallFunc actionWithTarget: self selector: @selector(removeFromParentWithCleanup)],
                                nil
                ]
        ];
    }
    
    state = gis_disappearing;
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
    if(award >= 0)
    {
        return ((state != gis_standing) || !isCatched);
    }
    
    return (isCatched);
}

- (void) reorder: (int) i
{
    if(self.parent)
    {
        [self.parent reorderChild: self z: i];
    }
}

@end