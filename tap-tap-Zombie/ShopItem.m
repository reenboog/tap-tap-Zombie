//
//  ShopItem.m
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopItem.h"

#import "Shop.h"


#define kIsMoneyPackKey     @"isMoneyPack"
#define kIsConsumableKey    @"isConsumable"
#define kCostKey            @"cost"
#define kPackSizeKey        @"packSize"
#define kHeaderKey          @"header"
#define kDescriptionKey     @"description"
#define kIconKey            @"ico"

@implementation ShopItem

@synthesize isMoneyPack;
@synthesize isConsumable;
@synthesize cost;
@synthesize packSize;
@synthesize header;
@synthesize desc;
@synthesize icon;

- (id) initWithDictionary: (NSDictionary *) dict
{
    if(self = [super init])
    {
        id data;
        
        data = [dict objectForKey: kIsMoneyPackKey];
        assert(data);
        isMoneyPack = [data boolValue];
        
        data = [dict objectForKey: kIsConsumableKey];
        assert(data);
        isConsumable = [data boolValue];
        
        data = [dict objectForKey: kCostKey];
        assert(data);
        cost = [data floatValue];
        
        data = [dict objectForKey: kPackSizeKey];
        assert(data);
        packSize = [data intValue];
        
        data = [dict objectForKey: kHeaderKey];
        assert(data);
        header = (NSString *)[data retain];
        
        data = [dict objectForKey: kDescriptionKey];
        assert(data);
        desc = (NSString *)[data retain];
        
        data = [dict objectForKey: kIconKey];
        assert(data);
        icon = (NSString *)[data retain];
    }
    
    return self;
}

+ (id) shopItemWithDictionary: (NSDictionary *) dict
{
    return [[[self alloc] initWithDictionary: dict] autorelease];
}

- (void) dealloc
{
    [header release];
    [desc release];
    [icon release];
    
    [super dealloc];
}

- (int) amount
{
    return [[Shop sharedShop] amountOfItem: self];
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"isMoneyPack: %@; isConsumable: %@; cost: %.2f; packSize: %i; header: %@; desc: %@; icon: %@",
                                        isMoneyPack ? @"YES" : @"NO", 
                                        isConsumable ? @"YES" : @"NO", 
                                        cost, 
                                        packSize, 
                                        header, 
                                        desc,
                                        icon];
}

@end
