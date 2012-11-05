//
//  ShopItem.h
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShopItem : NSObject
{
    BOOL isMoneyPack;
    BOOL isConsumable;
    
    float cost;
    int packSize;
    
    NSString *header;
    NSString *desc;
    
    NSString *icon;
}

@property (nonatomic, readonly) BOOL isMoneyPack;
@property (nonatomic, readonly) BOOL isConsumable;
@property (nonatomic, readonly) float cost;
@property (nonatomic, readonly) int packSize;
@property (nonatomic, readonly) NSString *header;
@property (nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) NSString *icon;

- (id) initWithDictionary: (NSDictionary *) dict;
+ (id) shopItemWithDictionary: (NSDictionary *) dict;

- (int) amount;

@end
