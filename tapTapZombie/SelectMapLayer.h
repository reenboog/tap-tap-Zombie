//
//  SelectMapLayer.h
//  tapTapZombie
//
//  Created by Alexander on 12.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface SelectMapLayer : CCLayer <CCPopupLayerDelegate>
{
    CCMenu *selectMapMenu;
    
    CCMenuItem *backBtn;
}

+ (CCScene *) scene;

@end
