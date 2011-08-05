//
//  ListController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/4/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "ListController.h"
//#import "AttendanceList.h"
//#import "ASIFormDataRequest.h"
//#import "SettingsManager.h"
#import "Event.h"
@implementation ListController
@synthesize uniqueMonths;
@synthesize eventSections;
@synthesize eventArray;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		uniqueMonths = [[NSMutableArray alloc] init];
		eventSections = [[NSMutableArray alloc] init];
    }
    
    return self;
}
- (void)dealloc
{
	[uniqueMonths release];
	[eventSections release];
	[eventArray release];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//	NSArray *eventArray = [AttendanceList sharedAttendanceList].eventsArray;
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
//	NSArray *eventArray = [AttendanceList sharedAttendanceList].eventsArray;
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
@end
