//
//  CCLabelBMFontNumeric.h
//  blobJump
//
//  Created by Alexander on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLabelBMFont.h"
#import "CCActionInterval.h"

// CCLabelBMFontNumeric class
@interface CCLabelBMFontNumeric : CCLabelBMFont
{
    float value;
}

@property (nonatomic, readonly) float value;

+ (id) labelWithValue: (float) v fntFile: (NSString *) fntFile;
- (id) initWithValue: (float) v fntFile: (NSString *) fntFile;

- (void) setValue: (float) value;

@end


// CCNumericTransitionTo class
// action only for CCLabelBMFontNumeric
@interface CCNumericTransitionTo : CCActionInterval <NSCopying>
{
    float startValue;
    float dstValue;
    float diffValue;
}

+(id) actionWithDuration: (ccTime) d value: (float) v;
-(id) initWithDuration: (ccTime) d value: (float) v;

@end
