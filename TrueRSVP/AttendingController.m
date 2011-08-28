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
- (void)refresh
{
	NSArray *attendanceInfo = [NetworkManager sharedNetworkManager].attendingList;
	[[AttendanceList sharedAttendanceList] updateEventsList:attendanceInfo];
	eventArray = [AttendanceList sharedAttendanceList].eventsArray;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd";
	for(Event *event in eventArray)
	{
		if([[df stringFromDate:event.eventDate] isEqual:[df stringFromDate:[NSDate date]]])
		{
			[[LocationManager sharedLocationManager] addEvent:event];
		}
	}
	[df release];
}
@end
