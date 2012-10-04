//
//  CCPopupLayerDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class CCPopupLayer;

@protocol CCPopupLayerDelegate <NSObject>

- (void) popupWillOpen: (CCPopupLayer *) popup;
- (void) popupDidFinishClosing: (CCPopupLayer *) popup;

@optional
- (void) popupDidFinishOpening: (CCPopupLayer *) popup;
- (void) popupWillClose: (CCPopupLayer *) popup;

@end
