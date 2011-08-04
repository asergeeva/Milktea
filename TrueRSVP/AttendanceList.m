//
//  Attendance.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AttendanceList.h"
#import "SynthesizeSingleton.h"
#import "Constants.h"
@implementation AttendanceList
SYNTHESIZE_SINGLETON_FOR_CLASS(AttendanceList);
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
		dateFormatter.dateFormat = dateFormatFromSQL;
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
