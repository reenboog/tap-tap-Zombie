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

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GameItemLogicDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        NSString *filename = [NSString stringWithFormat: @"zombies/zombie%i.png", arc4random()%4];
        sprite = [CCSprite spriteWithFile: filename];
        [self addChild: sprite];
        [self setContentSize: CGSizeMake(sprite.contentSize.width, sprite.contentSize.height)];
        
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
        float wayLength = [[keyPoints objectAtIndex: 0] CGPointValue].y - newPosition.y;
        
        float p = stepLength/fullWayLength;
        
        [self runAction:
                    [CCSequence actions:
                                    [CCMoveTo actionWithDuration: movingTime*p position: newPosition],
                                    [CCCallFunc actionWithTarget: self selector: @selector(moveToNextKeyPoint)],
                                    nil
                    ]
        ];
        
        [sprite runAction: [CCScaleTo actionWithDuration: movingTime*p scale: wayLength/fullWayLength]];
    
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
    
    [self moveToNextKeyPoint];
}

- (void) stand
{
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