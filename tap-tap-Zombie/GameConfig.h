//
//  GameConfig.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

// game config
#define kScreenWidth 480.0f
#define kScreenHeight 320.0f
#define kScreenCenterX (kScreenWidth/2)
#define kScreenCenterY (kScreenHeight/2)
#define kScreenCenter ccp(kScreenCenterX, kScreenCenterY)

#define kFontDefault @"font/gameFont.fnt"
#define kFontShopItemDescription @"font/shopItemDescriptionFont.fnt"

// game rules
#define kMinGameWays 3
#define kMaxGameWays 5
#define kMaxGameDifficulty 3

typedef enum 
{
    GameDifficultyEasy,
    GameDifficultyMedium,
    GameDifficultyHard,
    GameDifficultyVeryHard
} GameDifficulty;

typedef struct
{
    BOOL isStarted;
    BOOL isActive;
} GameStatus;
extern GameStatus gameStatus;

// return YES in one case from N
extern BOOL chance(unsigned N);

// tutorials
#define kGhostsTutorial @"ghostsTutorial"
#define kBonusTutorial @"bonusTutorial"
#define kTimeBonusTutorial @"timeBonusTutorial"
#define kBombTutorial @"bombTutorial"
#define kShieldTutorial @"shieldTutorial"

#endif // __GAME_CONFIG_H

