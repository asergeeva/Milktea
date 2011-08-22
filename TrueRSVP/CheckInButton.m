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
//	[eid release];
//	[uid release];
	[super dealloc];
}
@end
