

#import "IAPHelper.h"
#import "Settings.h"
#import "IAPConfig.h"

#import "cocos2d.h"

@implementation IAPHelper

@synthesize productIdentifiers;
@synthesize products;
//@synthesize purchasedProductIdentifiers;
@synthesize productRequest;

- (id) initWithProductIdentifiers: (NSSet *) ids
{
    if((self = [super init]))
    {    
        self.productIdentifiers = ids;
        
        //can be used with non-consumable products
//        NSMutableSet *purchaseProductIDs = [NSMutableSet set];
//        
//        for(NSString *productID in productIdentifiers) 
//        {
//            BOOL isProductPurchased = [[NSUserDefaults standardUserDefaults] boolForKey: productID];
//
//            if(isProductPurchased == YES) 
//            {
//                [purchasedProductIdentifiers addObject: productID];
//
//                CCLOG(@"Previously purchased: %@", productID);
//            }
//
//            CCLOG(@"Not purchased: %@", productID);
//        }
//
//        self.purchasedProductIdentifiers = purchaseProductIDs;
        
        [self requestProducts];

    }
    return self;
}

- (void) requestProducts
{    
    self.productRequest = [[[SKProductsRequest alloc] initWithProductIdentifiers: self.productIdentifiers] autorelease];

    productRequest.delegate = self;

    [self.productRequest start];
}

- (void) cancelProductRequest
{
    if(self.productRequest)
    {
        [self.productRequest cancel];
        
        self.productRequest = nil;
        
        //product request cancelled. Send notification about this.
    }
}

//- (double) priceForProduct: (NSString *) productID;
//{
//    double price = -1;
//    
//    for(SKProduct *product in products)
//    {
//        NSString *productIdentifier = product.productIdentifier;
//        
//        if([productIdentifier isEqualToString: productID])
//        {
//            price = [product.price doubleValue];
//            break;
//        }
//    }
//    
//    return price;
//}

- (void) productsRequest: (SKProductsRequest *) request didReceiveResponse: (SKProductsResponse *) response 
{
    self.products = response.products;
    
    self.productRequest = nil;

    if([response.invalidProductIdentifiers count] != 0)
    {
        CCLOG(@"some products were not recognized:");

        for(NSString *productID in response.invalidProductIdentifiers)
        {
            CCLOG(@"unknown product id: %@", productID);
        }
    }
    
    CCLOG(@"active items:");
    
    for(SKProduct *product in products)
    {
        CCLOG(@"rpduct: %@", product.description);
    }
    
    //notify everyone who interested in products: ui, logic...
    [[NSNotificationCenter defaultCenter] postNotificationName: kProductsLoadedNotification object: products];    
}

- (void) recordTransaction: (SKPaymentTransaction *) transaction 
{    
    // TODO: Record the transaction on the server side...    
}

- (void) provideContent: (NSString *) productIdentifier 
{
    //can be used with non-consumable products
//    //an item becomes purchased here...
//    
//    CCLOG(@"Toggling flag for: %@", productIdentifier);
//    
//    [[NSUserDefaults standardUserDefaults] setBool: TRUE forKey: productIdentifier];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [purchasedProductIdentifiers addObject: productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kProductPurchasedNotification object: productIdentifier];
}

- (void) completeTransaction: (SKPaymentTransaction *) transaction
{
    CCLOG(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
   
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *) transaction 
{    
    CCLOG(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
   
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *) transaction 
{
    if(transaction.error.code != SKErrorPaymentCancelled)
    {
        CCLOG(@"Transaction error: %@", transaction.error.localizedDescription);
        
        //maybe internet problems?
        [[NSNotificationCenter defaultCenter] postNotificationName: kInternetUnavailableNotification object: nil];
        
        return;
    }
    else
    {
        //user cancelled this transaction. Send notification.
        //unlock ui
        CCLOG(@"cancel pressed");
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kProductPurchaseFailedNotification object: transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) paymentQueue: (SKPaymentQueue *) queue updatedTransactions: (NSArray *) transactions
{
    for(SKPaymentTransaction *transaction in transactions)
    {
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction: transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction: transaction];
            //case SKPaymentTransactionStatePurchasing:
               // [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
               // break;
            default:
                break;
        }
    }
}

- (void) purchaseProductByID: (NSString *) productID
{    
    CCLOG(@"Buying %@...", productID);
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier: productID];
    [[SKPaymentQueue defaultQueue] addPayment: payment];
}

//can be used with non-consumable products
//- (BOOL) isProductPurchased: (NSString *) productID
//{
//    if([self.purchasedProductIdentifiers containsObject: productID])
//    {
//        return YES;
//    }
//    
//    return NO;
//}

- (void) dealloc
{
    self.productIdentifiers = nil;
    self.products = nil;
    
    //can be used with non-consumable products
    //self.purchasedProductIdentifiers = nil;
    
    self.productRequest = nil;
    
    [super dealloc];
}

@end
