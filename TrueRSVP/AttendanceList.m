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
		NSMutableDictionary *temp = [dictionary mutableCopy];
		for(NSString *s in dictionary)
		{
			if([dictionary objectForKey:s] == [NSNull null])
			{
				[temp removeObjectForKey:s];
				[temp setValue:@"" forKey:s];
			}
		}
		Event *event = [[Event alloc] init];
		event.eventID = [temp objectForKey:@"id"];
		event.eventOrganizer = [temp objectForKey:@"organizer"];
		event.eventName = [temp objectForKey:@"title"];
		event.eventDescription = [temp objectForKey:@"description"];
		event.eventAddress = [temp objectForKey:@"location_address"];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
		dateFormatter.dateFormat = dateFormatFromSQL;
		event.eventDate = [dateFormatter dateFromString:[temp objectForKey:@"event_datetime"]];
		[eventsArray addObject:event];
		[event release];
		[dateFormatter release];
		[temp release];
	}
}
- (void)dealloc
{
	[eventsArray release];
	[super dealloc];
}
@end
