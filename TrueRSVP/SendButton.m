//
//  SendButton.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/3/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "SendButton.h"

@implementation SendButton
@synthesize uid;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc
{
	[uid release];
	[super dealloc];
}
@end
