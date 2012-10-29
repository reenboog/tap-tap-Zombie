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
#define kMapIndexKey        @"mapIndex"

typedef struct
{
    NSArray *keyPoints;
} Track;

@class MapInfo;

@interface Map : NSObject
{
    int difficulty;
    int nTracks;
    Track *tracks;
    int index;
}

@property (nonatomic, readonly) int difficulty;
@property (nonatomic, readonly) int nTracks;
@property (nonatomic, readonly) Track *tracks;
@property (nonatomic, readonly) int index;

- (id) initWithDifficulty: (int) difficulty tracks: (NSArray *) tracks index: (int) index;
+ (id) mapWithDifficulty: (int) difficulty tracks: (NSArray *) tracks index: (int) index;

- (id) initWithDictionary: (NSDictionary *) dict;
+ (id) mapWithDictionary: (NSDictionary *) dict;

@end


@interface MapInfo : NSObject
{
    BOOL isPassed;
    float score;
}

@property (nonatomic) BOOL isPassed;
@property (nonatomic) float score;;

- (id) initWithDictionary: (NSDictionary *) dict;
+ (id) mapInfoWithDictionary: (NSDictionary *) dict;

@end
