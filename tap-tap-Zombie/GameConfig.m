//
//  GameConfig.c
//  tap-tap-Zombie
//
//  Created by Alexander on 17.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"


GameStatus gameStatus = {NO, NO};

BOOL chance(unsigned N)
{
    return (BOOL)(arc4random()%N == 0);
}
