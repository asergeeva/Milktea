//
//  CheckInButton.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "CheckInButton.h"

@implementation CheckInButton
@synthesize eid;
@synthesize uid;
@synthesize on;
@synthesize value;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		on = NO;
    }
    
    return self;
}
- (void)dealloc
{
//	[eid release];
//	[uid release];
	[super dealloc];
}
@end
