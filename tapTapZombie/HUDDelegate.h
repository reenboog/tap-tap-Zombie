//
//  HUDDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HUDDelegate <NSObject>

- (void) pause;
- (void) resume;
- (void) reset;

@end
