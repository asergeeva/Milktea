//
//  HostingController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "HostingController.h"
#import "HostingList.h"
#import "ASIFormDataRequest.h"
//#import "Constants.h"
#import "SettingsManager.h"
#import "NSDictionary_JSONExtensions.h"
@implementation HostingController
@synthesize uniqueMonths;
@synthesize eventSections;
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		[self refreshHosting];
		uniqueMonths = [[NSMutableArray alloc] init];
		eventSections = [[NSMutableArray alloc] init];
    }
    
    return self;
}
#pragma mark - Unload
- (void)dealloc
{
	[uniqueMonths release];
	[eventSections release];
	[super dealloc];
}
#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"someCell"];
	if(tableCell == nil)
	{
		tableCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"someCell"] autorelease];		
		tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		tableCell.textLabel.font = [UIFont systemFontOfSize:14];
		tableCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
		tableCell.detailTextLabel.textColor = [UIColor grayColor];
	}
	
	//	EventAttending *event = ((EventAttending*)[[Attendance sharedAttendance].eventsArray objectAtIndex:indexPath.section + indexPath.row]);		
	Event *event = [((NSMutableArray*)[eventSections objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
	if(event.eventName.length > 15)
	{
		tableCell.textLabel.text = [NSString stringWithFormat:@" %@...", [event.eventName substringToIndex:14]];
	}
	else
	{
		tableCell.textLabel.text = [NSString stringWithFormat:@" %@", event.eventName];
	}
	
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
	df.dateFormat = @"MMMM d - hh:mm a";
	tableCell.detailTextLabel.text = [df stringFromDate:event.eventDate];
	[df release];
	return tableCell;
}
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//	return UITableViewCellAccessoryDisclosureIndicator;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//	NSMutableArray *dates = [[NSMutableArray alloc] init];
	NSArray *eventArray = [HostingList sharedHostingList].eventsArray;
	for(Event *event in eventArray)
	{
		NSDate *date = event.eventDate;
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		df.dateFormat = @"yyyy-M/MM";
		if(![uniqueMonths containsObject:[df stringFromDate:date]])
		{
			[uniqueMonths addObject:[df stringFromDate:date]];
			NSMutableArray *newSection = [[NSMutableArray alloc] init];
			[eventSections addObject:newSection];
			[newSection release];
		}
		[df release];
	}
	
	return uniqueMonths.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSString *selectedMonth = [uniqueMonths objectAtIndex:section];
	NSArray *eventArray = [HostingList sharedHostingList].eventsArray;
	int counter = 0;
	for(Event *event in eventArray)
	{
		NSDate *date = event.eventDate;
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		df.dateFormat = @"yyyy-M/MM";
		if([[df stringFromDate:date] isEqualToString:selectedMonth])
		{
			counter++;
			[((NSMutableArray*)[eventSections objectAtIndex:section]) addObject:event];
		}
		[df release];
	}
	return counter;
}
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	NSString *selectedMonth = [uniqueMonths objectAtIndex:section];
//	NSDateFormatter *df = [[NSDateFormatter alloc] init];
//	df.dateFormat = @"yyyy-M/MM";
//	if([selectedMonth isEqualToString:[df stringFromDate:[NSDate date]]])
//	{
//		return @"This Month";
//	}
//	else
//	{
//		NSDate *fromString = [df dateFromString:selectedMonth];
//		df.dateFormat = @"MMMM";
//		return [df stringFromDate:fromString];
//	}
//}
#pragma mark - Other
- (void)refreshHosting
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager] APILocation], @"getHostingEvents/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	NSArray *hostingInfo = [NSDictionary dictionaryWithJSONString:[request responseString] error:nil];
	[[HostingList sharedHostingList] updateEventsList:hostingInfo];
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

