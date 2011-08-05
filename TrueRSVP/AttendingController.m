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
//#import "NSDictionary_JSONExtensions.h"
@implementation AttendingController
//@synthesize list;
//@synthesize uniqueMonths;
//@synthesize eventSections;
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		[self refresh];
//		uniqueMonths = [[NSMutableArray alloc] init];
//		eventSections = [[NSMutableArray alloc] init];
    }
    
    return self;
}
#pragma mark - Unload
- (void)dealloc
{
//	[list release];
//	[uniqueMonths release];
//	[eventSections release];
	[super dealloc];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return [super numberOfSectionsInTableView:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [super tableView:tableView numberOfRowsInSection:section];
}
#pragma mark - UITableViewDataSource
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"someCell"];
//	if(tableCell == nil)
//	{
//		tableCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"someCell"] autorelease];		
//		tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//		tableCell.textLabel.font = [UIFont systemFontOfSize:14];
//		tableCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
//		tableCell.detailTextLabel.textColor = [UIColor grayColor];
//	}
//	Event *event = [((NSMutableArray*)[eventSections objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
//	if(event.eventName.length > 15)
//	{
//		tableCell.textLabel.text = [NSString stringWithFormat:@" %@...", [event.eventName substringToIndex:14]];
//	}
//	else
//	{
//		tableCell.textLabel.text = [NSString stringWithFormat:@" %@", event.eventName];
//	}
//	
//	NSDateFormatter *df = [[NSDateFormatter alloc]init];
//	df.dateFormat = @"MMMM d - hh:mm a";
//	tableCell.detailTextLabel.text = [df stringFromDate:event.eventDate];
//	[df release];
//	return tableCell;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	NSArray *eventArray = [AttendanceList sharedAttendanceList].eventsArray;
//	for(Event *event in eventArray)
//	{
//		NSDate *date = event.eventDate;
//		NSDateFormatter *df = [[NSDateFormatter alloc] init];
//		df.dateFormat = @"yyyy-M/MM";
//		if(![uniqueMonths containsObject:[df stringFromDate:date]])
//		{
//			[uniqueMonths addObject:[df stringFromDate:date]];
//			NSMutableArray *newSection = [[NSMutableArray alloc] init];
//			[eventSections addObject:newSection];
//			[newSection release];
//		}
//		[df release];
//	}
//	
//	return uniqueMonths.count;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//	NSString *selectedMonth = [uniqueMonths objectAtIndex:section];
//	NSArray *eventArray = [AttendanceList sharedAttendanceList].eventsArray;
//	int counter = 0;
//	for(Event *event in eventArray)
//	{
//		NSDate *date = event.eventDate;
//		NSDateFormatter *df = [[NSDateFormatter alloc] init];
//		df.dateFormat = @"yyyy-M/MM";
//		if([[df stringFromDate:date] isEqualToString:selectedMonth])
//		{
//			counter++;
//			[((NSMutableArray*)[eventSections objectAtIndex:section]) addObject:event];
//		}
//		[df release];
//	}
//	return counter;
//}
#pragma mark - Other
- (void)refresh
{
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager] APILocation], @"getAttendingEvents/"]];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"], @"getAttendingEvents/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	NSArray *attendanceInfo = [NSDictionary dictionaryWithJSONString:[request responseString] error:nil];
	[[AttendanceList sharedAttendanceList] updateEventsList:attendanceInfo];
	eventArray = [AttendanceList sharedAttendanceList].eventsArray;
}
@end
