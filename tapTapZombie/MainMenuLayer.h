//
//  HelloWorldLayer.h
//  tapTapZombie
//
//  Created by Alexander on 16.08.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"


@interface MainMenuLayer : CCLayer <CCPopupLayerDelegate>
{
    CCMenuItem *playBtn;
    CCMenuItem *shopBtn;
}

+ (CCScene *) scene;

@end
