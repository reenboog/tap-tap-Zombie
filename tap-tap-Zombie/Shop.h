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

#define kSuperblast     @"Superblast"
#define kTimeCheater    @"Time cheater"
#define kShield         @"The S.H.I.E.L.D."
#define kGreatLottery   @"The Great Lottery"
#define kResurrection   @"The resurrection"
#define kMoneyPack0     @"Money pack #1"
#define kMoneyPack1     @"Money pack #2"

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
