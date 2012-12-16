//
//  SpriteFramesLoader.m
//  tap-tap-Zombie
//
//  Created by Alexander Sokolenko on 17.12.12.
//
//

#import "SpriteFramesLoader.h"
#import "cocos2d.h"


@implementation SpriteFramesLoader

+ (void) loadSpriteFramesWithPlistFile: (NSString *) filename
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource: filename ofType: @"plist"];
    NSArray *frameNames = [NSArray arrayWithContentsOfFile: path];

    for(NSString *name in frameNames)
    {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: name];
        CGRect textureRect = CGRectMake(0, 0, texture.contentSizeInPixels.width, texture.contentSizeInPixels.height);
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture: texture rect: textureRect];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame: frame name: name];
    }
}

@end
