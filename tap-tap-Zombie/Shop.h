//
//  Shop.h
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShopItem.h"


typedef enum 
{
    PurchaseStatusSuccess,
    PurchaseStatusNotEnoughMoney,
    PurchaseStatusError
} PurchaseStatus;

#define kDefault0       @"Default0"
#define kDefault1       @"Default1"
#define kDefault2       @"Default2"
#define kDefault3       @"Default3"
#define kDefault4       @"Default4"
#define kMoneyPack0     @"MoneyPack0"
#define kMoneyPack1     @"MoneyPack1"

@interface Shop : NSObject
{
    NSArray *items;
}

@property (nonatomic, readonly) NSArray *items;

+ (Shop *) sharedShop;
+ (void) releaseShop;

- (ShopItem *) itemWithName: (NSString *) name;

- (int) amountOfItem: (ShopItem *) item;
- (int) amountOfItemWithName: (NSString *) name;

- (PurchaseStatus) purchaseItem: (ShopItem *) item;
- (PurchaseStatus) purchaseItemWithName: (NSString *) name;

@end
