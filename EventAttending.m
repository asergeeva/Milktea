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
@synthesize eventAddress;
@synthesize eventDate;
- (id)init
{
    self = [super init];
    if (self) {
		eventName = [[NSMutableString alloc] init];
		eventDescription = [[NSMutableString alloc] init];
		eventAddress = [[NSMutableString alloc] init];
//		eventDate = [[NSDate alloc] init];
    }
    
    return self;
}
- (void)dealloc
{
	[eventName release];
	[eventDescription release];
	[eventAddress release];
	[eventDate release];
	[super dealloc];
}
@end
