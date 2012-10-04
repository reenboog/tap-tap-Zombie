
#import <Foundation/Foundation.h>


@interface Settings: NSObject
{
    int coins;
    NSMutableDictionary *purchases;
}

@property (nonatomic) int coins;
@property (nonatomic, readonly) NSMutableDictionary *purchases;

+ (Settings *) sharedSettings;
+ (void) releaseSettings;

- (void) load;
- (void) save;

@end