
#import <Foundation/Foundation.h>

#define kMaxGameCycle 3

@interface Settings: NSObject
{
    int coins;
    NSMutableDictionary *purchases;
    NSMutableArray *showedTutorials;
    
    float bestScore;
    float bestArcadeScore;
    
    unsigned gameCycle;
    NSMutableArray *arcadeMaps;
}

@property (nonatomic) int coins;
@property (nonatomic, readonly) NSMutableDictionary *purchases;
@property (nonatomic, readonly) NSMutableArray *showedTutorials;
@property (nonatomic) float bestScore;
@property (nonatomic) float bestArcadeScore;
@property (nonatomic) unsigned gameCycle;
@property (nonatomic, retain) NSMutableArray *arcadeMaps;

+ (Settings *) sharedSettings;
+ (void) releaseSettings;

- (void) load;
- (void) save;

@end