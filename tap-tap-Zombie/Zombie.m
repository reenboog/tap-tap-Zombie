//
//  Zombie.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "Zombie.h"

#import "AnimationLoader.h"


@interface Zombie()

- (void) moveToNextKeyPoint;
- (void) stand;
- (void) runAway;

@end


@implementation Zombie

@synthesize onFinish;
@synthesize award;
@synthesize type;

+ (void) initialize
{
    [[CCTextureCache sharedTextureCache] addImage: @"zombies/zombies.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"zombies/zombies.plist"];
    
    [AnimationLoader loadAnimationsWithPlist: @"zombies/animations"];
}

#pragma mark init and dealloc
- (id) initWithDelegate: (id<ZombieDelegate>) delegate_  type: (ZombieType) type_ awardFactor: (float) af
{
    if(self = [super init])
    {
        delegate = delegate_;
        type = type_;
        
        sprite = [CCSprite node];
        sprite.anchorPoint = ccp(0.5f, 0);
        [self addChild: sprite];
        
//        NSString *labelStr;
//        ccColor3B c;
        switch(type)
        {
            case ZombieTypeNormal:  
            {
                skinIndex = arc4random()%5;
//                labelStr = @"normal";
//                c = ccc3(0, 255, 0);
                award = 10*af;
            } break;
                
            case ZombieTypeBad:
            {
//                labelStr = @"bad";
//                c = ccc3(255, 0, 0);
                award = 5*af;
                skinIndex = 5;
            } break;
                
            case ZombieTypeBonus: 
            {
//                labelStr = @"bonus"; 
//                c = ccc3(0, 255, 0);
                award = 20*af;
                skinIndex = 7;
            } break;
                
            case ZombieTypeTimeBonus: 
            {
//                labelStr = @"time bonus"; 
//                c = ccc3(0, 255, 0);
                award = 5.0f;
                skinIndex = 8;
            } break;
                
            case ZombieTypeShield:
            {
//                labelStr = @"shield";
//                c = ccc3(0, 0, 255);
                award = 0;
                skinIndex = 6;
            } break;
        }
//        CCLabelBMFont *label = [CCLabelBMFont labelWithString: labelStr fntFile: kFontDefault];
//        label.color = c;
//        label.anchorPoint = ccp(0.5f, 0);
//        [self addChild: label];
        
        isStarting = NO;
        onFinish = NO;
        isCaptured = NO;
        
        sprite.scale = 1;
        sprite.opacity = 0;
        
        self.scale = 0.2f;
    }
    
    return self;
}

+ (id) zombieWithDelegate: (id<ZombieDelegate>) delegate type: (ZombieType) type awardFactor: (float) af
{
    return [[[self alloc] initWithDelegate: delegate type: type awardFactor: af] autorelease];
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

- (void) setOpacity: (float) opacity
{
    [sprite setOpacity: opacity];
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
    
//    [self stopAllActions];
    
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
                                                    [CCScaleTo actionWithDuration: 0.2f 
                                                                            scale: 1.2f
                                                    ],
                                                    [CCMoveTo actionWithDuration: 0.3f
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
    
    [sprite runAction:
                    [CCSpawn actions:
                                    [CCFadeIn actionWithDuration: 0.3f],
                                    nil
                    ]
    ];
    
    [sprite runAction:
                [CCRepeatForever actionWithAction:
                                    [CCSequence actions:
                                                    [CCScaleTo actionWithDuration: 0.25f scaleX: 0.95f scaleY: 1.05f],
                                                    [CCScaleBy actionWithDuration: 0.25f scaleX: 1.05f scaleY: 0.95f],
                                                    nil
                                    ]
                ]
    ];
    
    [self runAction:
                [CCEaseSineIn actionWithAction: 
                                        [CCScaleTo actionWithDuration: movingTime 
                                                                scale: 0.8f]
                ] 
    ];
    
    [self moveToNextKeyPoint];
    
    NSString *animationName = [NSString stringWithFormat: @"zombieMoving%i", skinIndex];
    CCAnimate *movingAnimation = [CCAnimate actionWithAnimation: 
                                                    [[CCAnimationCache sharedAnimationCache] animationByName: animationName]
                                          restoreOriginalFrame: NO];
    [sprite runAction:
                [CCRepeatForever actionWithAction: movingAnimation]
    ];
}

- (void) capture
{
    if(isCaptured) return;
    
    isCaptured = YES;
    
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
