//
//  ZombieDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Zombie;

@protocol ZombieDelegate

- (void) zombieFinished: (Zombie *) zombie;
- (void) zombieLeftFinish: (Zombie *) zombie;
- (void) zombieCaptured: (Zombie *) zombie;
- (void) zombiePassed: (Zombie *) zombie;

@end
