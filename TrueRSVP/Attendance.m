//
//  Attendance.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "Attendance.h"
#import "SynthesizeSingleton.h"
#import "EventAttending.h"
@implementation Attendance
SYNTHESIZE_SINGLETON_FOR_CLASS(Attendance);
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
- (void)updateAttendance:(NSArray*)attendance
{
	for(NSDictionary *dictionary in attendance)
	{
		EventAttending *event = [[EventAttending alloc] init];
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
