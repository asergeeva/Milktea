//
//  EventAttending.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "EventAttending.h"

@implementation EventAttending
@synthesize eventName;
@synthesize eventDescription;
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
	[eventName release];
	[eventDescription release];
	[super dealloc];
}
@end
