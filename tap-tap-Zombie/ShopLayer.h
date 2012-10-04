//
//  ShopLayer.h
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "NotEnoughMoneyAlert.h"


@interface ShopLayer : CCLayer
{
    CCLayer *pagesLayer;
    int nCurrentPage;
    
    CCMenuItem *rightBtn;
    CCMenuItem *leftBtn;
    
    CCLabelBMFontNumeric *coinsLabel;
    
    NotEnoughMoneyAlert *notEnoughMoneyAlert;
}

- (id) initWithCurrentPageItem: (NSString *) itemName;

+ (id) shopLayer;
+ (id) shopLayerWithCurrentPageItem: (NSString *) itemName;

- (void) showWithAnimationAndEnable;
- (void) disableAndHideWithAnimation;

@end
