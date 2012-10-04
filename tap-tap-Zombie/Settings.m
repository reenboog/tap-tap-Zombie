
#import "Settings.h"
#import "GameConfig.h"


#define kCoinsKey       @"coins"
#define kPurchasesKey   @"purchases"

@implementation Settings

@synthesize coins;
@synthesize purchases;

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
    
    [super dealloc];
}

#pragma mark -

#pragma mark load/save
- (void) load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id data;
    
    data = [defaults objectForKey: kCoinsKey];
    coins = data ? [data intValue] : 635;
    
    data = [defaults objectForKey: kPurchasesKey];
    purchases = data ? [data retain] : [[NSMutableDictionary alloc] init];
}

- (void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: [NSNumber numberWithInt: coins] forKey: kCoinsKey];
    [defaults setObject: purchases forKey: kPurchasesKey];
    
    [defaults synchronize];
}

@end
