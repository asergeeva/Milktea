//
//  HostingController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "HostingController.h"
#import "HostingList.h"
#import "NSDictionary_JSONExtensions.h"
@implementation HostingController
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
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"], @"getHostingEvents/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	NSArray *hostingInfo = [NSDictionary dictionaryWithJSONString:[request responseString] error:nil];
	[[HostingList sharedHostingList] updateEventsList:hostingInfo];
	eventArray = [HostingList sharedHostingList].eventsArray;
}
+ (NSString*)getSectionText:(NSString*)selectedMonth
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-M/MM";
	
	NSDateFormatter *dfYear = [[NSDateFormatter alloc] init];
	dfYear.dateFormat = @"yyyy";
	
	int year = [[selectedMonth substringToIndex:3] intValue];
	
	NSString *text;
	if([selectedMonth isEqualToString:[df stringFromDate:[NSDate date]]])
	{
		text = @"   This Month";
	}
	else if (year != [[dfYear stringFromDate:[NSDate date]] intValue])
	{
		NSDate *fromString = [df dateFromString:selectedMonth];
		df.dateFormat = @"   MMMM yyyy";
		text = [df stringFromDate:fromString];
	}
	else
	{
		NSDate *fromString = [df dateFromString:selectedMonth];
		df.dateFormat = @"   MMMM";
		text = [df stringFromDate:fromString];
	}
	[df release];
	[dfYear release];
	return text;
}
@end

