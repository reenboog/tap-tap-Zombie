//
//  ZombiesWaveDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ZombiesWave;
@class Zombie;
@class Map;

@protocol ZombiesWaveDelegate

//- (void) zombiesWaveLeftFinish: (ZombiesWave *) zombiesWave;
//- (void) zombiesWaveFinished: (ZombiesWave *) zombiesWave;
- (void) zombiesWavePassed: (ZombiesWave *) zombiesWave;

- (void) zombieFinished: (Zombie *) zombie;
- (void) zombieLeftFinish: (Zombie *) zombie;
- (void) zombieCaptured: (Zombie *) zombie;

@property (nonatomic, readonly) Map *map;
@property (nonatomic, readonly) BOOL isShieldModActivated;

@end
