//
//  SoundsConfig.h
//  tap-tap-Zombie
//
//  Created by hmmvot on 11/16/12.
//
//

#import "SimpleAudioEngine.h"

#define PLAY_BUTTON_CLICK_SOUND() \
[[SimpleAudioEngine sharedEngine] playEffect:  @"sounds/button_clicked.mp3"];

#define PLAY_ZOMBIE_CAPTURED_SOUND() \
[[SimpleAudioEngine sharedEngine] playEffect: [NSString stringWithFormat: @"sounds/zombie_captured_%i.mp3", arc4random()%3]];

#define PLAY_SHOP_PURCHASE_SOUND() \
[[SimpleAudioEngine sharedEngine] playEffect:  @"sounds/shop_purchased.mp3"];