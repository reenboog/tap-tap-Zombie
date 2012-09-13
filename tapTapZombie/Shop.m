//
//  Shop.m
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Shop.h"

#import "Settings.h"


#define kShopKey    @"shop"

@implementation Shop

@synthesize items;

#pragma mark singleton
static Shop *sharedShop = nil;
+ (Shop *) sharedShop
{
    if(!sharedShop)
    {
        sharedShop = [[Shop alloc] init];
    }
    
    return sharedShop;
}

+ (void) releaseShop
{
    [sharedShop release];
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

- (void) dealloc
{
    [items release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark load with plist
- (void) loadShopWithPlistFile: (NSString *) filename
{
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] 
                                                                           pathForResource: filename 
                                                                           ofType: @"plist"]];
    NSAssert(plistDict, @"no such file '%@'.", filename);
    
    NSArray *shop = [plistDict objectForKey: kShopKey];
    assert(shop);
    
    NSMutableArray *items_ = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in shop)
    {
        [items_ addObject: [ShopItem shopItemWithDictionary: dict]];
    }
    
    items = [[NSArray alloc] initWithArray: items_];
    [items_ release];
}

#pragma mark -

#pragma mark item with name
- (ShopItem *) itemWithName: (NSString *) name
{
    for(ShopItem *item in items)
    {
        if([item.header isEqualToString: name])
        {
            return item;
        }
    }
    
    return nil;
}

#pragma mark -

#pragma mark amount
- (int) amountOfItem: (ShopItem *) item
{
    return item ? [[[Settings sharedSettings].purchases objectForKey: item.header] intValue] : 0;
}

- (int) amountOfItemWithName: (NSString *) name
{
    return [self amountOfItem: [self itemWithName: name]];
}

#pragma mark -

#pragma mark purchase
- (PurchaseStatus) purchaseItem: (ShopItem *) item
{
    if(!item) return PurchaseStatusError;
    
    int pack = item.packSize;
    float cost = item.cost;
    
    // money pack purchasing
    if(item.isMoneyPack)
    {
        [Settings sharedSettings].coins += pack;
        [[Settings sharedSettings] save];
        
        return PurchaseStatusSuccess;
    }
    
    // other items purchasing
    if([Settings sharedSettings].coins < cost)
    {
        return PurchaseStatusNotEnoughMoney;  
    }
    
    pack += [[[Settings sharedSettings].purchases objectForKey: item.header] intValue];
    
    [[Settings sharedSettings].purchases setObject: [NSNumber numberWithInt: pack] forKey: item.header];
    [Settings sharedSettings].coins -= (int)cost;
    [[Settings sharedSettings] save];
    
    return PurchaseStatusSuccess;
}

- (PurchaseStatus) purchaseItemWithName: (NSString *) name
{
    return [self purchaseItem: [self itemWithName: name]];
}

@end
