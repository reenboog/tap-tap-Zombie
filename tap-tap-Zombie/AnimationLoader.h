//
//  AimationLoader.h
//  woti_ref0
//
//  Created by Alexander on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface AnimationLoader : NSObject

+ (CCAnimation *) loadAnimationWithPlist: (NSString *) file andName: (NSString *) name;
+ (NSArray *) loadAnimationsWithPlist: (NSString *) file;

@end
