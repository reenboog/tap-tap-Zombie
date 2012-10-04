//
//  CCLabelBMFonrNumeric.m
//  blobJump
//
//  Created by Alexander on 17.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLabelBMFontNumeric.h"


@implementation CCLabelBMFontNumeric

@synthesize value;

#pragma mark init and dealloc
+ (id) labelWithValue: (float) v fntFile: (NSString *) fntFile
{
	return [[[self alloc] initWithValue: v fntFile: fntFile] autorelease];
}

- (id) initWithValue: (float) v fntFile: (NSString *) fntFile
{	
	if (self = [super initWithString: [NSString stringWithFormat: @"%i", (int)round(v)] fntFile: fntFile])
    {
		value = v;
	}

	return self;
}

#pragma mark -

- (void) setValue: (float) v
{
    float oldValue = value;
    value = v;
    
    if(round(value) != round(oldValue))
    {
        [self setString: [NSString stringWithFormat: @"%i", (int)round(value)]];
    }
}

@end


@implementation CCNumericTransitionTo

+(id) actionWithDuration: (ccTime) t value: (float) a
{	
	return [[[self alloc] initWithDuration: t value: a ] autorelease];
}

-(id) initWithDuration: (ccTime) t value:(float) a
{
	if( (self=[super initWithDuration: t]) )
		dstValue = a;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] value: dstValue];
	return copy;
}

-(void) startWithTarget: (CCNode *) aTarget
{
	[super startWithTarget: aTarget];
	
	startValue = [(CCLabelBMFontNumeric *)target_ value];
	
	diffValue = dstValue - startValue;
}
-(void) update: (ccTime) t
{
	[(CCLabelBMFontNumeric *)target_ setValue: startValue + diffValue*t];
}

@end
