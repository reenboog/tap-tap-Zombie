//
//  Zombie.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"

#import "GameConfig.h"


@interface Zombie()

- (void) moveToNextKeyPoint;
- (void) stand;
- (void) runAway;

@end


@implementation Zombie

@synthesize onFinish;
@synthesize award;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<ZombieDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        int zombieType = arc4random()%4;
        sprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"zombies/zombie%i.png", zombieType]];
        sprite.anchorPoint = ccp(0.5f, 0);
        [self addChild: sprite];
        
        isStarting = NO;
        onFinish = NO;
        
        if(zombieType == 3)
        {
            award = -5;
        }
        else
        {
            award = 5;
        }
    }
    
    return self;
}

+ (id) zombieWithDelegate: (id<ZombieDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [keyPoints release];
    
    [super dealloc];
}

#pragma mark -

- (void) stopAllActions
{
    [super stopAllActions];
    
    [sprite stopAllActions];
}

#pragma mark -

- (void) moveToNextKeyPoint
{
    assert(keyPoints);
    assert(isStarting);
    
    if(++nCurrentKeyPoint < [keyPoints count])
    {
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

- (void) stand
{
    assert(isStarting);
    
    onFinish = YES;
    
    [delegate zombieFinished: self];
    
    [self stopAllActions];
    
    [self runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: standingTime],
                                [CCCallFunc actionWithTarget: self selector: @selector(runAway)],
                                nil
                ]
    ];
}

- (void) runAway
{
    onFinish = NO;
    
    [delegate zombieLeftFinish: self];
    
    [self runAction:
                    [CCSequence actions:
                                    [CCSpawn actions:
                                                    [CCScaleTo actionWithDuration: 0.3f 
                                                                            scale: 1.2f
                                                    ],
                                                    [CCMoveTo actionWithDuration: 0.5f
                                                                        position: ccp(self.position.x, -150.0f)
                                                    ],
                                                    nil
                                    ],
                                    [CCCallFuncO actionWithTarget: delegate 
                                                         selector: @selector(zombiePassed:)
                                                           object: self
                                    ],
                                    nil
                    ]
    ];
}

- (void) runWithKeyPoints: (NSArray *) kp movingTime: (ccTime) mt standingTime: (ccTime) st
{
    assert(!isStarting);
    
    isStarting = YES;
    
    keyPoints = [kp retain];
    movingTime = mt;
    standingTime = st;
    
    nCurrentKeyPoint = 0;
    
    self.position = [[keyPoints objectAtIndex: nCurrentKeyPoint] CGPointValue];
    
    sprite.scale = 0.2f;
    sprite.opacity = 0;
    
    [sprite runAction:
                    [CCSpawn actions:
                                    [CCFadeIn actionWithDuration: 0.3f],
                                    [CCEaseSineIn actionWithAction: 
                                                            [CCScaleTo actionWithDuration: movingTime 
                                                                                    scale: 0.8f]
                                    ],
                                    nil
                    ]
    ];
    
    [self moveToNextKeyPoint];
}

- (void) capture
{
    [self stopAllActions];
    
    [delegate zombieLeftFinish: self];
    
    [sprite runAction:
                    [CCSequence actions:
                                    [CCSpawn actions:
                                                    [CCScaleTo actionWithDuration: 0.3f 
                                                                            scale: 0
                                                    ],
                                                    [CCFadeOut actionWithDuration: 0.2f],
                                                    nil
                                    ],
                                    [CCCallFuncO actionWithTarget: delegate 
                                                         selector: @selector(zombiePassed:)
                                                           object: self
                                    ],
                                    nil
                    ]
    ];
}

@end
