
#import <Foundation/Foundation.h>


@interface Settings: NSObject
{
    int coins;
    NSMutableDictionary *purchases;
    NSMutableArray *showedTutorials;
}

@property (nonatomic) int coins;
@property (nonatomic, readonly) NSMutableDictionary *purchases;
@property (nonatomic, readonly) NSMutableArray *showedTutorials;

+ (Settings *) sharedSettings;
+ (void) releaseSettings;

- (void) load;
- (void) save;

@end