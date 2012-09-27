//
//  Game.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct
{
    BOOL isFailed;
    float score;
    int perfectWaves;
} GameOverStatus;

@interface Game : NSObject
{
    BOOL isStarted;
    BOOL isActive;
    
    int mapIndex;
    int difficulty;
    
    GameOverStatus gameOverStatus;
}

@property (nonatomic) BOOL isStarted;
@property (nonatomic) BOOL isActive;

@property (nonatomic) int mapIndex;
@property (nonatomic) int difficulty;

@property (nonatomic, readonly) GameOverStatus gameOverStatus;

+ (Game *) sharedGame;
+ (void) releaseGame;

- (void) runMainMenuScene;
- (void) runSelectMapScene;
- (void) runGameScene;

- (void) reset;

- (void) setGameOverStatus: (GameOverStatus *) status;
- (void) dropGameOverStatus;

@end
