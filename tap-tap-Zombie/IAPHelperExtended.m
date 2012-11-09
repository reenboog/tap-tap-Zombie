
#import "IAPHelperExtended.h"
#import "IAPConfig.h"

#import "SimpleAudioEngine.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

#import "cocos2d.h"

@implementation IAPHelperExtended

@synthesize hud;

static IAPHelperExtended *sharedHelper = nil;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    self.hud = nil;
    
    [super dealloc];
}

+ (IAPHelperExtended *) sharedHelper
{
    if(sharedHelper == nil)
    {
        sharedHelper = [[IAPHelperExtended alloc] init];
    }
    
    return sharedHelper;
}

- (id) init
{
    if((self = [super initWithProductIdentifiers: [NSSet setWithObjects: kMoney0ID, kMoney1ID, nil]]))
    {
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(onItemPurchaseRequest:) 
                                                     name: kIAPItemPurchaseRequestTag 
                                                   object: nil
        ];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(dismissHUD)
                                                     name: kProductPurchaseFailedNotification
                                                   object: nil
        ];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(dismissHUD)
                                                     name: kProductPurchasedNotification
                                                   object: nil
        ];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(onInternetUnavailable)
                                                     name: kInternetUnavailableNotification
                                                   object: nil
        ];
    }
    
    return self;
}

- (void) onItemPurchaseRequest: (NSNotification *) notification
{
    NSString *productID = notification.object;
    
    //purchase this item from app store
    if([productID isEqualToString: kMoney0ID] || [productID isEqualToString: kMoney1ID])
    {
        //check internet connection first
        Reachability *internetAvailability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [internetAvailability currentReachabilityStatus];
        
        if(networkStatus == NotReachable)
        {
            //[[NSNotificationCenter defaultCenter] postNotificationName: kInternetUnavailableNotification object: nil];
            [self onInternetUnavailable];
            
            return;
        }
        
        //lock the interface        
        [[NSNotificationCenter defaultCenter] postNotificationName: kIAPBlockContentTag object: nil];
        
        [self purchaseProductByID: productID];
        
        self.hud = [MBProgressHUD showHUDAddedTo: [CCDirector sharedDirector].openGLView animated: YES];
        self.hud.labelText          = @"Purchasing";
        self.hud.detailsLabelText   = @"Please wait. Trying to purchase your product.";
        
        [self performSelector: @selector(onTimeLimitExceeded) withObject: nil afterDelay: 30.0];
    }
    //this item is ingame
    else
    {
        //assume we have enough money (in other case we won't find ourselves in here)
        [[NSNotificationCenter defaultCenter] postNotificationName: kProductPurchasedNotification object: productID];
    }
}

- (void) onInternetUnavailable
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kIAPBlockContentTag object: nil];
    
    //show message
    if(!self.hud)
    {
        self.hud = [MBProgressHUD showHUDAddedTo: [CCDirector sharedDirector].openGLView animated: YES];
    }
    self.hud.labelText          = @"No Internet connection";
    self.hud.detailsLabelText   = @"Internet connection required to proceed.";
    
    [self performSelector: @selector(dismissHUD) withObject: nil afterDelay: 3.0];
}

- (void) onTimeLimitExceeded
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self];
    //[self dismissHUD];
    
    self.hud.labelText          = @"Error";
    self.hud.detailsLabelText   = @"Something is wrong.";
    
    [self performSelector: @selector(dismissHUD) withObject: nil afterDelay: 2.0];
}

- (void) dismissHUD
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self];
    
    [MBProgressHUD hideHUDForView: [CCDirector sharedDirector].openGLView animated: YES];
    
    self.hud = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kIAPReleaseContentTag object: nil];
}

@end
