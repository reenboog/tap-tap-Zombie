
#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

@interface IAPHelper: NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> 
{
    NSSet *productIdentifiers;
    //can be used with non-consumable products
    //NSMutableSet *purchasedProductIdentifiers;
    //an array of SKProduct items
    NSArray *products;

    SKProductsRequest *productRequest;
}

@property (nonatomic, retain) NSSet *productIdentifiers;
//can be used with non-consumable products
//@property (nonatomic, retain) NSMutableSet *purchasedProductIdentifiers;

@property (nonatomic, retain) NSArray *products;

@property (nonatomic, retain) SKProductsRequest *productRequest;

- (id) initWithProductIdentifiers: (NSSet *) ids;

- (void) requestProducts;
- (void) cancelProductRequest;

//- (double) priceForProduct: (NSString *) productID;

- (void) purchaseProductByID: (NSString *) productID;

//can be used with non-consumable products
//- (BOOL) isProductPurchased: (NSString *) productID;

@end
