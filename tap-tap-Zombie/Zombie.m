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
@synthesize type;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<ZombieDelegate>) delegate_  type: (ZombieType) type_
{
    if(self = [super init])
    {
        delegate = delegate_;
        type = type_;
        
        int zombieType = arc4random()%4;
        sprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"zombies/zombie%i.png", zombieType]];
        sprite.anchorPoint = ccp(0.5f, 0);
        [self addChild: sprite];
        
        NSString *labelStr;
        switch(type)
        {
            case ZombieTypeNormal:  labelStr = @"normal"; break;
            case ZombieTypeBad:     labelStr = @"bad"; break;
            case ZombieTypeJumper:  labelStr = @"jumper"; break;
            case ZombieTypeShield:  labelStr = @"shield"; break;
        }
        CCLabelBMFont *label = [CCLabelBMFont labelWithString: labelStr fntFile: kFontDefault];
        label.anchorPoint = ccp(0.5f, 0);
        switch(type)
        {
            case ZombieTypeJumper:
            case ZombieTypeNormal:  label.color = ccc3(0, 255, 0); break;
            case ZombieTypeBad:     label.color = ccc3(255, 0, 0); break;
            case ZombieTypeShield:  label.color = ccc3(0, 0, 255); break;
        }
        [self addChild: label];
        
        isStarting = NO;
        onFinish = NO;
        
        award = 10;
    }
    
    return self;
}

+ (id) zombieWithDelegate: (id<ZombieDelegate>) delegate type: (ZombieType) type
{
    return [[[self alloc] initWithDelegate: delegate type: type] autorelease];
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
    
    [self stopAllActions];
    
    [self runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: standingTime],
                                [CCCallFunc actionWithTarget: self selector: @selector(runAway)],
                                nil
                ]
    ];
    
    [delegate zombieFinished: self];
}

- (void) runAway
{
    onFinish = NO;
    
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
    
    [delegate zombieLeftFinish: self];
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
    
    [delegate zombieCaptured: self];
}

@end
