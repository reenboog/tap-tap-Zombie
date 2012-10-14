//
//  Wave.h
//  tap-tap-Zombie
//
//  Created by Alexander on 12.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Wave : NSObject
{
    NSArray *paths;
    int weight;
    int tracksNeed;
    BOOL hasJumpers;
}

@property (nonatomic, readonly) NSArray *paths;
@property (nonatomic, readonly) int weight;
@property (nonatomic, readonly) int tracksNeed;
@property (nonatomic, readonly) BOOL hasJumpers;

- (id) initWithPaths: (NSString *) strPaths;
+ (id) waveWithPaths: (NSString *) strPaths;

@end
