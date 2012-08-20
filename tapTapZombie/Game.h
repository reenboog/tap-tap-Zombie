//
//  Game.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kGameMaxDifficulty 3

@class GameLayer;
@class HUD;

@interface Game : NSObject
{
    BOOL isActive;
    
    GameLayer *gameLayer;
    HUD *hud;
    
    float timer;
    
    int difficulty;
    
    int nWays;
    CGPoint *startPoints;
    CGPoint *endPoints;
}

@property (nonatomic) BOOL isActive;
@property (nonatomic) int difficulty;

@property (nonatomic, readonly) int nWays;
@property (nonatomic, readonly) CGPoint *startPoints;
@property (nonatomic, readonly) CGPoint *endPoints;

+ (Game *) sharedGame;

- (void) startGame;
- (void) exitGame;
- (void) resetGame;
- (void) pauseGame;
- (void) resumeGame;

- (void) tick: (float) dt;

- (void) reset;

@end
