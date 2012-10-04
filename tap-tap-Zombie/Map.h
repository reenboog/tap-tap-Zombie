//
//  Map.h
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kMapDifficultyKey   @"difficulty"
#define kMapTracksKey       @"tracks"
#define kMapBackgroundKey   @"background"

typedef struct
{
    NSArray *keyPoints;
} Track;

@interface Map : NSObject
{
    int difficulty;
    int nTracks;
    Track *tracks;
    NSString *background;
}

@property (nonatomic, readonly) int difficulty;
@property (nonatomic, readonly) int nTracks;
@property (nonatomic, readonly) Track *tracks;
@property (nonatomic, readonly) NSString *background;

- (id) initWithDifficulty: (int) difficulty tracks: (NSArray *) tracks background: (NSString *) background;
+ (id) mapWithDifficulty: (int) difficulty tracks: (NSArray *) tracks background: (NSString *) background;

- (id) initWithDictionary: (NSDictionary *) dict;
+ (id) mapWithDictionary: (NSDictionary *) dict;

@end
