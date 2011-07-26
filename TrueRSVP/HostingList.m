//
//  HostingList.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "HostingList.h"
#import "SynthesizeSingleton.h"
@implementation HostingList
SYNTHESIZE_SINGLETON_FOR_CLASS(HostingList);
@synthesize eventsArray;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		eventsArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}
- (void)updateEventsList:(NSArray*)eventsList
{
	for(NSDictionary *dictionary in eventsList)
	{
		Event *event = [[Event alloc] init];
		event.eventID = [dictionary objectForKey:@"id"];
		event.eventOrganizer = [dictionary objectForKey:@"organizer"];
		event.eventName = [dictionary objectForKey:@"title"];
		event.eventDescription = [dictionary objectForKey:@"description"];
		event.eventAddress = [dictionary objectForKey:@"location_address"];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
		dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
		event.eventDate = [dateFormatter dateFromString:[dictionary objectForKey:@"event_datetime"]];
		[eventsArray addObject:event];
		[event release];
		[dateFormatter release];
	}
}
- (void)dealloc
{
	[eventsArray release];
	[super dealloc];
}
@end
