//
//  HUD.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface HUD : CCLayer <CCPopupLayerDelegate>
{
    CCMenuItem *pauseBtn;
}

+ (id) hud;

@end
