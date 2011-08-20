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
#import "NetworkManager.h"
@implementation AttendingController
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
		[self refresh];
    }
    
    return self;
}
#pragma mark - Unload
- (void)dealloc
{
	[super dealloc];
}
#pragma mark - Other
- (void)refresh
{
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"], @"getAttendingEvents/"]];
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//	[request startSynchronous];
	NSArray *attendanceInfo = [NetworkManager sharedNetworkManager].attendingList;
	[[AttendanceList sharedAttendanceList] updateEventsList:attendanceInfo];
	eventArray = [AttendanceList sharedAttendanceList].eventsArray;
}
@end
