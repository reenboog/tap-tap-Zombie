//
//  ShopLayer.m
//  tapTapZombie
//
//  Created by Alexander on 13.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "SoundsConfig.h"

#import "ShopLayer.h"

#import "Shop.h"
#import "Settings.h"

#import "IAPConfig.h"


#define kAmountLabelTag 11
#define kPageMenuTag 12

@interface ShopLayer()

- (CCLayer *) pageWithItems: (NSArray *) items;
- (CCMenuItem *) pageItemWithShopItem: (ShopItem *) shopItem;

- (void) setCurrentPage: (int) pageNumber animated: (BOOL) animated;
- (int) pageNumberWithItem: (NSString *) itemName;
- (void) showPageWithItem: (NSString *) itemName animated: (BOOL) animated;

@end


@implementation ShopLayer

#pragma mark init and dealloc
- (id) init
{
    return [self initWithCurrentPageItem: nil];
}

+ (id) shopLayer
{
    return [[[self alloc] init] autorelease];
}

- (id) initWithCurrentPageItem: (NSString *) itemName;
{
    if(self = [super init])
    {
        pagesLayer = [CCLayer node];
        [self addChild: pagesLayer z: 1];
        
        NSArray *shopItems = [Shop sharedShop].items;
        NSArray *pages = [[NSArray alloc] initWithObjects: 
                                        [shopItems objectsAtIndexes: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, 3)]],
                                        [shopItems objectsAtIndexes: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(3, 2)]],
                                        [shopItems objectsAtIndexes: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(5, 2)]],
                                        nil];
        
        int pageIndex = 0;
        for(NSArray *pageItems in pages)
        {
            CCLayer *page = [self pageWithItems: pageItems];
            page.tag = pageIndex++;
            page.position = ccp(kScreenCenterX + kScreenWidth, kScreenCenterY);
            [pagesLayer addChild: page];
        }
        
        [pages release];
        
        // buttons
        CCSprite *btnSprite;
        CCSprite *btnSpriteOn;
        CCMenu *menu;
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/rightBtn.png"];
        btnSpriteOn = [CCSprite spriteWithFile: @"buttons/rightBtnOn.png"];
        rightBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                           selectedSprite: btnSpriteOn
                                                   target: self
                                                 selector: @selector(rightBtnCallback)];
        menu = [CCMenu menuWithItems: rightBtn, nil];
        menu.position = ccp(kScreenWidth - 20.0f - rightBtn.contentSize.width/2, kScreenCenterY);
        rightBtn.position = ccp(rightBtn.contentSize.width + 40.0f, 0);
        [self addChild: menu z: 0];
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/leftBtn.png"];
        btnSpriteOn = [CCSprite spriteWithFile: @"buttons/leftBtnOn.png"];
        leftBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnSpriteOn
                                                  target: self
                                                selector: @selector(leftBtnCallback)];
        menu = [CCMenu menuWithItems: leftBtn, nil];
        menu.position = ccp(20.0f + leftBtn.contentSize.width/2, kScreenCenterY);
        leftBtn.position = ccp(-leftBtn.contentSize.width - 40.0f, 0);
        [self addChild: menu z: 0];
        
        // coins label
        coinsLabel = [CCLabelBMFontNumeric labelWithValue: [Settings sharedSettings].coins fntFile: kFontDefault];
        coinsLabel.anchorPoint = ccp(1, 0);
        coinsLabel.position = ccp(kScreenWidth - 20.0f, 20.0f);
        coinsLabel.opacity = 0;
        [self addChild: coinsLabel];
        
        // not enough money alert
        notEnoughMoneyAlert = [NotEnoughMoneyAlert node];
        [self addChild: notEnoughMoneyAlert z: 2];
        
        // set current page
        int nPage = [self pageNumberWithItem: itemName];
        nCurrentPage = nPage < 0 ? 0 : nPage;
        
        // IAPs
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(onItemPurchased:) 
                                                     name: kProductPurchasedNotification
                                                   object: nil
        ];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(blockContent) 
                                                     name: kIAPBlockContentTag
                                                   object: nil
        ];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(releaseContent) 
                                                     name: kIAPReleaseContentTag
                                                   object: nil
        ];
    }
    
    return self;
}

+ (id) shopLayerWithCurrentPageItem: (NSString *) itemName
{
    return [[[self alloc] initWithCurrentPageItem: itemName] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark onEnter
- (void) onEnter
{
    [super onEnter];
    
    [self disableWithChildren];
}

#pragma mark -

#pragma mark init pages and items
- (CCLayer *) pageWithItems: (NSArray *) items
{
    CCLayer *page = [CCLayer node];
    page.isRelativeAnchorPoint = YES;
    page.anchorPoint = ccp(0.5f, 0.5f);
    
    CCMenu *pageMenu = [CCMenu menuWithItems: nil];
    for(ShopItem *item in items)
    {
        CCMenuItem *pageItem = [self pageItemWithShopItem: item];
        [pageMenu addChild: pageItem];
    }
    [pageMenu alignItemsVertically];
    pageMenu.position = kScreenCenter;
    [page addChild: pageMenu z: 0 tag: kPageMenuTag];
    
    return page;
}

- (CCMenuItem *) pageItemWithShopItem: (ShopItem *) shopItem
{
    assert(shopItem);
    
    // main
    CCMenuItem *pageItem = [CCMenuItemSprite itemFromNormalSprite: [CCSprite spriteWithFile: @"shop/item.png"]
                                                   selectedSprite: [CCSprite spriteWithFile: @"shop/item.png"]
                                                           target: self
                                                         selector: @selector(pageItemBtnCallback:)];
    
    float itemWidth = pageItem.contentSize.width;
    float itemHeight = pageItem.contentSize.height;
    
    // icon
    CCSprite *iconSprite = [CCSprite spriteWithFile: @"shop/icon.png"];
    iconSprite.anchorPoint = ccp(1, 0.5f);
    iconSprite.position = ccp(itemWidth - 40.0f, itemHeight/2 - 2.0f);
    [pageItem addChild: iconSprite z: -1];
    
    // header
    CCLabelBMFont *headerLabel = [CCLabelBMFont labelWithString: shopItem.header fntFile: kFontDefault];
    headerLabel.scale = 0.9f;
    headerLabel.anchorPoint = ccp(0, 1);
    headerLabel.position = ccp(34.0f, itemHeight - 20.0f);
    [pageItem addChild: headerLabel];
    
    // description
    CCLabelBMFontMultiline *descriptionLabel = [CCLabelBMFontMultiline labelWithString: shopItem.desc
                                                                               fntFile: kFontShopItemDescription
                                                                            dimensions: CGSizeMake(itemWidth*0.7f, itemHeight)
                                                                             alignment: LeftAlignment];
//    CCLabelBMFont *descriptionLabel = [CCLabelBMFont labelWithString: shopItem.desc fntFile: kFontDefault];
//    descriptionLabel.scale = 0.7f;
    descriptionLabel.color = ccc3(50, 50, 50);
    descriptionLabel.anchorPoint = ccp(0, 1);
    descriptionLabel.position = ccp(36.0f, itemHeight - 70.0f);
    [pageItem addChild: descriptionLabel];
    
    // icon
    CCSprite *icon = [CCSprite spriteWithSpriteFrameName: shopItem.icon];
    icon.anchorPoint = ccp(1, 1);
    icon.position = ccp(itemWidth - 25.0f, itemHeight - 25.0f);
    [pageItem addChild: icon z: -1];
    
    // cost
    NSString *costLabelText = shopItem.isMoneyPack  ? [NSString stringWithFormat: @"%.2f", shopItem.cost]
                                                    : [NSString stringWithFormat: @"%.0f", shopItem.cost];
    CCLabelBMFont *costLabel = [CCLabelBMFont labelWithString: costLabelText fntFile: kFontDefault]; 
    costLabel.scale = 0.7f;
    costLabel.anchorPoint = ccp(1, 0);
    costLabel.position = ccp(itemWidth - 32.0f, 10.0f);
    [pageItem addChild: costLabel];
    
    // amount
    if(!shopItem.isMoneyPack)
    {
        NSString *amountLabelText = [NSString stringWithFormat: @"%i", [shopItem amount]];
        CCLabelBMFont *amountLabel = [CCLabelBMFont labelWithString: amountLabelText fntFile: kFontDefault];
        amountLabel.anchorPoint = ccp(1, 1);
        amountLabel.position = ccp(itemWidth - 40.0f, itemHeight - 20.0f);
//        amountLabel.color = ccc3(200, 200, 200);
        [pageItem addChild: amountLabel z: 0 tag: kAmountLabelTag];
    }
    
    pageItem.userData = shopItem;
    
    return pageItem;
}

#pragma mark -

#pragma mark show and hide
- (void) showWithAnimationAndEnable
{
    CCNode *currentPage = [pagesLayer getChildByTag: nCurrentPage];
    currentPage.position = ccp(kScreenCenterX, kScreenCenterY + kScreenHeight);
    currentPage.scale = 1.0f;
    [currentPage runAction: [CCEaseBackOut actionWithAction: [CCMoveTo actionWithDuration: 0.3f position: kScreenCenter]]];
    
    CCAction *showBtnAction = [CCEaseBackOut actionWithAction: [CCMoveTo actionWithDuration: 0.3f position: ccp(0, 0)]];
    [rightBtn runAction: [[showBtnAction copy] autorelease]];
    [leftBtn  runAction: showBtnAction];
    
    [coinsLabel runAction: [CCFadeIn actionWithDuration: 0.3f]];
}

- (void) disableAndHideWithAnimation
{
    [self disableWithChildren];
    
    CCNode *currentPage = [pagesLayer getChildByTag: nCurrentPage];
    CGPoint p = ccp(kScreenCenterX, kScreenCenterY + kScreenHeight);
    [currentPage runAction: [CCEaseBackIn actionWithAction: [CCMoveTo actionWithDuration: 0.3f position: p]]];
    
    p = ccp(rightBtn.contentSize.width + 40.0f, 0);
    [rightBtn runAction: [CCEaseBackIn actionWithAction: [CCMoveTo actionWithDuration: 0.3f position: p]]];
    
    p = ccp(-leftBtn.contentSize.width - 40.0f, 0);
    [leftBtn runAction: [CCEaseBackIn actionWithAction: [CCMoveTo actionWithDuration: 0.3f position: p]]];
    
    [coinsLabel runAction: [CCFadeOut actionWithDuration: 0.3f]];
    
    if(notEnoughMoneyAlert.isShown)
    {
        [notEnoughMoneyAlert hide];
    }
}

#pragma mark -

#pragma mark set current page
- (void) setCurrentPage: (int) nPage
{
    CCNode *newCurrentPage = [pagesLayer getChildByTag: nPage];
    newCurrentPage.position = kScreenCenter;
    
    CCNode *oldCurrentPage = [pagesLayer getChildByTag: nCurrentPage];
    oldCurrentPage.position = ccp(kScreenWidth*2, kScreenCenterY);
    
    nCurrentPage = nPage;
}

- (void) setCurrentPageAnimated: (int) nPage
{
    [self disableWithChildren];
    
    CCNode *newCurrentPage = [pagesLayer getChildByTag: nPage];
    CCNode *oldCurrentPage = [pagesLayer getChildByTag: nCurrentPage];
    
    BOOL toRight =  ((nPage > nCurrentPage) || ((nPage == 0) && (nCurrentPage == [[pagesLayer children] count] - 1))) &&
                    !((nCurrentPage == 0) && (nPage == [[pagesLayer children] count] - 1));
    
    float ncpX = toRight ? (kScreenWidth + kScreenCenterX) : -kScreenWidth;
    float ocpX = toRight ? -kScreenWidth : kScreenWidth*2;
    
    newCurrentPage.position = ccp(ncpX, kScreenCenterY);
    [newCurrentPage runAction: [CCEaseBackOut actionWithAction: [CCMoveTo actionWithDuration: 0.4f position: kScreenCenter]]];
    
    [oldCurrentPage runAction:
                        [CCSequence actions:
                                        [CCMoveTo actionWithDuration: 0.3f position: ccp(ocpX, kScreenCenterY)],
                                        [CCCallFunc actionWithTarget: self selector: @selector(enableWithChildren)],
                                        nil
                        ]
    ];
    
    nCurrentPage = nPage;
}

- (void) setCurrentPage: (int) nPage animated: (BOOL) animated
{
    if(nPage == nCurrentPage) return;
    
    nPage = nPage < 0 ? 0 : nPage > [[pagesLayer children] count] - 1 ? [[pagesLayer children] count] - 1 : nPage;
    
    if(animated)
    {
        [self setCurrentPageAnimated: nPage];
        
        return;
    }
    
    [self setCurrentPage: nPage];
}

- (int) pageNumberWithItem: (NSString *) itemName
{
    if(!itemName) return 0;
    
    int nPage = 0;
    for(CCNode *page in [pagesLayer children])
    {
        for(CCMenuItem *pageItem in [[page getChildByTag: kPageMenuTag] children])
        {
            NSString *shopItemHeader = ((ShopItem *)(pageItem.userData)).header;
            if([shopItemHeader isEqualToString: itemName])
            {
                return nPage;
            }
        }
        
        nPage++;
    }
    
    return 0;
}

- (void) showPageWithItem: (NSString *) itemName animated: (BOOL) animated
{
    if(nCurrentPage < 0) return;
    
    int nPage = [self pageNumberWithItem: itemName];
    
    if(nPage < 0) return;
    
    [self setCurrentPage: nPage animated: animated];
}

#pragma mark -

#pragma mark callbacks
- (void) rightBtnCallback
{
    int nPage = nCurrentPage + 1;
    nPage = nPage > [[pagesLayer children] count] - 1 ? 0 : nPage;
    
    [self setCurrentPage: nPage animated: YES];
    
    PLAY_BUTTON_CLICK_SOUND();
}

- (void) leftBtnCallback
{
    int nPage = nCurrentPage - 1;
    nPage = nPage < 0 ? [[pagesLayer children] count] - 1 : nPage;
    
    [self setCurrentPage: nPage animated: YES];
    
    PLAY_BUTTON_CLICK_SOUND();
}

#pragma mark purchase
- (void) pageItemBtnCallback: (CCNode *) sender
{
    itemForPurchasing = sender;
    ShopItem *shopItem = (ShopItem *)itemForPurchasing.userData;
    
    if([shopItem.header isEqualToString: kMoneyPack0])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: kIAPItemPurchaseRequestTag
                                                            object: kMoney0ID
                                                          userInfo: nil];
    }
    else if([shopItem.header isEqualToString: kMoneyPack1])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: kIAPItemPurchaseRequestTag
                                                            object: kMoney1ID
                                                          userInfo: nil
        ];
    }
    else
    {
        int cost = shopItem.cost;
        
        if([Settings sharedSettings].coins - cost >= 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: kIAPItemPurchaseRequestTag
                                                                object: kIngameFake
                                                              userInfo: nil
            ];
        }
        else
        {
            [notEnoughMoneyAlert show];
            [self showPageWithItem: kMoneyPack0 animated: YES];
        }
    }

//    ShopItem *shopItem = (ShopItem *)sender.userData;
//    PurchaseStatus purhaseStatus = [[Shop sharedShop] purchaseItem: shopItem];
//    
//    switch(purhaseStatus)
//    {
//        case PurchaseStatusSuccess:
//        {
//            if(!shopItem.isMoneyPack)
//            {
//                int amount = [shopItem amount];
//                NSString *amountLabelText = [NSString stringWithFormat: @"%i", amount];
//                [(CCLabelBMFont *)[sender getChildByTag: kAmountLabelTag] setString: amountLabelText];
//            }
//            
//            [coinsLabel runAction: [CCNumericTransitionTo actionWithDuration: 1.0f value: [Settings sharedSettings].coins]];
//        } break;
//            
//        case PurchaseStatusNotEnoughMoney:
//        {
//            [notEnoughMoneyAlert show];
//            [self showPageWithItem: kMoneyPack0 animated: YES];
//        } break;
//            
//        case PurchaseStatusError:
//        {
//        
//        } break;
//    }
    
    PLAY_BUTTON_CLICK_SOUND();
}

#pragma mark IAPs notifications
- (void) onItemPurchased: (NSNotification *) notification;
{
    //
    ShopItem *shopItem = (ShopItem *)itemForPurchasing.userData;
    
    NSString *productID = notification.object;
    
//    int cost = shopItem.cost;
    
    if([productID isEqualToString: kIngameFake])
    {
        [[Shop sharedShop] purchaseItem: shopItem];
        
        int amount = [shopItem amount];
        NSString *amountLabelText = [NSString stringWithFormat: @"%i", amount];
        [(CCLabelBMFont *)[itemForPurchasing getChildByTag: kAmountLabelTag] setString: amountLabelText];
        
        [coinsLabel runAction: [CCNumericTransitionTo actionWithDuration: 1.0f value: [Settings sharedSettings].coins]];
//        
//        int num = [(NSNumber *)[[Settings sharedSettings].purchasedItems objectAtIndex: itemForPurchasing] intValue];
//        num += shopItemPackSizes[itemForPurchasing];
//        
//        [Settings sharedSettings].coins -= cost;
//        [[Settings sharedSettings].purchasedItems replaceObjectAtIndex: itemForPurchasing withObject: [NSNumber numberWithInt: num]];
//        [[Settings sharedSettings] save];
//        
//        CCNode *item = [items objectAtIndex: itemForPurchasing];
//        [(CCLabelBMFont *)[item getChildByTag: kNumberTag] setString: [NSString stringWithFormat: @"%i", num]];
//        
//        [coinsLabelNumeric runAction: [CCNumericTransitionTo actionWithDuration: 1.0f value: [Settings sharedSettings].coins]];
    }
    else if([productID isEqualToString: kMoney0ID])
    {
        [Settings sharedSettings].coins += kMoney0Value;
        [[Settings sharedSettings] save];
        
        [coinsLabel runAction: [CCNumericTransitionTo actionWithDuration: 1.0f value: [Settings sharedSettings].coins]];
    }
    else if([productID isEqualToString: kMoney1ID])
    {
        [Settings sharedSettings].coins += kMoney1Value;
        [[Settings sharedSettings] save];
        
        [coinsLabel runAction: [CCNumericTransitionTo actionWithDuration: 1.0f value: [Settings sharedSettings].coins]];
    }

    [self releaseContent];
    
    PLAY_SHOP_PURCHASE_SOUND();
}

- (void) blockContent
{
    if([self getChildByTag: kIAPFakeMenuTag])
    {
        return;
    }
    
    CCMenuItem *fakeItem = [CCMenuItem itemWithTarget: self selector: nil];
    fakeItem.contentSize = CGSizeMake(1024, 768);
    
    fakeItem.position = ccp(512, 384);
    
    CCMenu *fakeMenu = [CCMenu menuWithItems: fakeItem, nil];
    fakeMenu.position = ccp(0, 0);
    
    [self addChild: fakeMenu z: zIAPFakeMenu tag: kIAPFakeMenuTag];
    
    //show awaiting View
}

//money purchased or out of time to wait
- (void) releaseContent
{
    [self removeChildByTag: kIAPFakeMenuTag cleanup: YES];
    
    //remove awaiting UI
}

@end
