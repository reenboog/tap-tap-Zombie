//
//  GameOverPopupDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct 
{
    BOOL isFailed;
} GameOverStatus;


@protocol GameOverPopupDelegate <CCPopupLayerDelegate>

- (void) restart;
- (void) exit;

@property (nonatomic, readonly) BOOL isGameFailed;

@end
