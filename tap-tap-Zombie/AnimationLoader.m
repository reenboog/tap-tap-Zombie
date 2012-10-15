//
//  AimationLoader.m
//  woti_ref0
//
//  Created by Alexander on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationLoader.h"

@implementation AnimationLoader

+ (CCAnimation *) loadAnimationWithPlist: (NSString *) file andName: (NSString *) name
{
    CCAnimation *animation = nil;
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: file ofType: @"plist"]];
    if(!plistDict)
    {
        CCLOG(@"no such file! - %@", file);
        return nil;
    }
    
    NSDictionary *animationDict = [plistDict objectForKey: name];
    
    if(!animationDict)
    {
        CCLOG(@"no such animation! - %@", name);
        return nil;
    }
    
    animation = [CCAnimation animation];
    
    float animationDelay = [[animationDict objectForKey: @"delay"] floatValue];
    [animation setDelay: animationDelay];
    
    NSString *animationFrames = [animationDict objectForKey: @"frames"];
    
    NSArray *frameIndices = [animationFrames componentsSeparatedByString: @","];
    
    for(NSString *frameIndex in frameIndices)
    {
        NSString *frameName = [NSString stringWithFormat: @"%@%@.png", name, frameIndex];
        
        [animation addFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName]];
    }
    
    [[CCAnimationCache sharedAnimationCache] addAnimation: animation name: name];
    
    return animation;
}

+ (NSArray *) loadAnimationsWithPlist: (NSString *) file
{
    NSMutableArray *animations = [NSMutableArray array];
    
    NSDictionary *plistDict =  [NSDictionary dictionaryWithContentsOfFile: 
                                                                [[NSBundle mainBundle] pathForResource: file ofType: @"plist"]
                               ];
    
    assert(plistDict);

    NSArray *keys = [plistDict allKeys];
    NSEnumerator *e = [keys objectEnumerator];
    NSString *name = nil;
    
    while(name = [e nextObject])
    {
        NSDictionary *animationDict = [plistDict objectForKey: name];
        
        CCAnimation *animation = [CCAnimation animation];

        float animationDelay = [[animationDict objectForKey: @"delay"] floatValue];
        [animation setDelay: animationDelay];

        NSString *animationFrames = [animationDict objectForKey: @"frames"];

        NSArray *frameIndices = [animationFrames componentsSeparatedByString: @","];

        for(NSString *frameIndex in frameIndices)
        {
            NSString *frameName = [NSString stringWithFormat: @"%@%@.png", name, frameIndex];

            [animation addFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName]];
        }

        [[CCAnimationCache sharedAnimationCache] addAnimation: animation name: name];
        
        [animations addObject: animation];
    }
    
    return [NSArray arrayWithArray: animations];
}

@end
