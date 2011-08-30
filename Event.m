//
//  EventAttending.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "Event.h"

@implementation Event
@synthesize eventID;
@synthesize eventOrganizer;
@synthesize eventName;
@synthesize eventDescription;
@synthesize eventAddress;
@synthesize eventDate;
@synthesize eventTwitter;
- (id)init
{
    self = [super init];
    if (self) {
		eventID = [[NSMutableString alloc] init];
		eventName = [[NSMutableString alloc] init];
		eventDescription = [[NSMutableString alloc] init];
		eventAddress = [[NSMutableString alloc] init];
		eventTwitter = [[NSMutableString alloc] init];
//		eventDate = [[NSDate alloc] init];
    }
    
    return self;
}
- (void)dealloc
{
	[eventID release];
//	[eventOrganizer release];
	[eventName release];
	[eventDescription release];
	[eventAddress release];
	[eventTwitter release];
//	[eventDate release];
	[super dealloc];
}
@end
