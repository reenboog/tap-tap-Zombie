//
//  ShopPopup.h
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class ShopLayer;

@interface ShopPopup : CCPopupLayer
{
    CCLayerColor *background;
    CCMenuItem *closePopupBtn;
    
    ShopLayer *shopLayer;
}

@end
