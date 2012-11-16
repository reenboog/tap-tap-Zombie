
#import "Settings.h"
#import "GameConfig.h"


#define kCoinsKey               @"coins"
#define kPurchasesKey           @"purchases"
#define kShowedTutorials        @"showedTutorials"
#define kBestScoreKey           @"bestScoreKey"
#define kBestArcadeScoreKey     @"bestArcadeScoreKey"
#define kGameCycleKey           @"gameCycleKey"
#define kArcadeMapsKey          @"arcadeMapsKey"

#define kDefaultBestScore 1000
#define kDefaultBestArcadeScore 3000

@implementation Settings

@synthesize coins;
@synthesize purchases;
@synthesize showedTutorials;
@synthesize bestScore;
@synthesize bestArcadeScore;
@synthesize arcadeMaps;
@synthesize gameCycle;


Settings *sharedSettings = nil;
+ (Settings *) sharedSettings
{
    if(!sharedSettings)
    {
        sharedSettings = [[Settings alloc] init];
    }
    
    return sharedSettings;
}

+ (void) releaseSettings
{
    [sharedSettings release];
}

- (id) init
{
    if((self = [super init]))
    {
        [self load];
    }
    
    return self;
}

- (void) dealloc
{
    [self save];
    
    [purchases release];
    [showedTutorials release];
    [arcadeMaps release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark load/save
- (void) load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id data;
    
    data = [defaults objectForKey: kCoinsKey];
    coins = 10000;//data ? [data intValue] : 0;
    
    data = [defaults objectForKey: kPurchasesKey];
    purchases = data ? [data retain] : [[NSMutableDictionary alloc] init];
    
    data = [defaults objectForKey: kShowedTutorials];
    showedTutorials = data ? [data retain] : [[NSMutableArray alloc] init];
    
    data = [defaults objectForKey: kBestScoreKey];
    bestScore = data ? [data floatValue] : kDefaultBestScore + arc4random()%100;
    
    data = [defaults objectForKey: kBestArcadeScoreKey];
    bestArcadeScore = data ? [data floatValue] : kDefaultBestArcadeScore + arc4random()%500;
    
    data = [defaults objectForKey: kGameCycleKey];
    gameCycle = data ? [data intValue] : 0;
    
    data = [defaults objectForKey: kArcadeMapsKey];
    arcadeMaps = data ? data : [[NSMutableArray alloc] initWithObjects:  [NSNumber numberWithInt: 2],
                                                                         [NSNumber numberWithInt: 4],
                                                                         [NSNumber numberWithInt: 14],
                                                                         [NSNumber numberWithInt: 19],
                                                                         nil];
}

- (void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: [NSNumber numberWithInt: coins] forKey: kCoinsKey];
    [defaults setObject: purchases forKey: kPurchasesKey];
    [defaults setObject: showedTutorials forKey: kShowedTutorials];
    [defaults setObject: [NSNumber numberWithInt: bestScore] forKey: kBestScoreKey];
    [defaults setObject: [NSNumber numberWithInt: bestArcadeScore] forKey: kBestArcadeScoreKey];
    [defaults setObject: [NSNumber numberWithInt: gameCycle] forKey: kGameCycleKey];
    [defaults setObject: arcadeMaps forKey: kArcadeMapsKey];
    
    [defaults synchronize];
}

@end
