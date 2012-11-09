
#import "IAPHelper.h"

@class MBProgressHUD;

@interface IAPHelperExtended: IAPHelper 
{
    MBProgressHUD *hud;
}

@property (nonatomic, retain) MBProgressHUD *hud;

+ (IAPHelperExtended *) sharedHelper;

- (void) onItemPurchaseRequest: (NSNotification *) notification;

- (void) onInternetUnavailable;

- (void) onTimeLimitExceeded;

- (void) dismissHUD;


@end
