//
//  AttendingController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AttendingController.h"
#import "AttendanceList.h"
#import "NSDictionary_JSONExtensions.h"
#import "LocationManager.h"
#import "User.h"
#import "CJSONDeserializer.h"
@implementation AttendingController
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
		[NetworkManager sharedNetworkManager].attendingDelegate = self;
		[self refresh];
    }
    
    return self;
}
#pragma mark - Unload
- (void)dealloc
{
	[NetworkManager sharedNetworkManager].attendingDelegate = nil;
	[super dealloc];
}
- (void)updateAttending
{
	[self refresh];
}
#pragma mark - Other
- (void)checkIfAttending:(ASIHTTPRequest*)request
{
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	if(![[dictionary objectForKey:@"is_attending"] isEqual:@"1"])
	{
		for(Event *event in eventArray)
		{
			if([event.eventID isEqual:[dictionary objectForKey:@"event_id"]])
				[[LocationManager sharedLocationManager] addEvent:event];
			break;
		}
	}
//	NSArray *guestNames = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil];
//	for (NSDictionary *dictionary in guestNames)
//	{
//		if([[dictionary objectForKey:@"id"] isEqual:[User sharedUser].uid])
//		{
//			if(![[dictionary objectForKey:@"is_attending"] isEqual:@"1"])
//			{
//				for(Event *event in eventArray)
//				{
//					if([event.eventID isEqual:[dictionary objectForKey:@"event_id"]])
//						[[LocationManager sharedLocationManager] addEvent:event];
//					break;
//				}
//			}
//		}
//	}
}
- (void)refresh
{
	NSArray *attendanceInfo = [NetworkManager sharedNetworkManager].attendingList;
	[[AttendanceList sharedAttendanceList] updateEventsList:attendanceInfo];
	eventArray = [AttendanceList sharedAttendanceList].eventsArray;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd";
	//REDO THIS USING NEW BACKEND
	for(Event *event in eventArray)
	{
		if([[df stringFromDate:event.eventDate] isEqual:[df stringFromDate:[NSDate date]]])
		{
			[[NetworkManager sharedNetworkManager] isCheckedInWithEID:event.eventID didFinish:@selector(checkIfAttending:) delegate:self];
//			if([[NetworkManager sharedNetworkManager] isCheckedInWithEID:event.eventID]);
		}
	}
	[df release];
}
@end
