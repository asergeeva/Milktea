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
#import "Constants.h"
#import "Event.h"
#import <QuartzCore/QuartzCore.h>
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
//		bars = [[NSMutableArray alloc] init];
    }
    
    return self;
}
- (void)dealloc
{
	[uniqueMonths release];
	for(NSMutableArray *array in eventSections)
	{
		[array removeAllObjects];
//		[array release];
	}
	[eventSections release];
//	[bars release];
//	[eventArray release];
	[super dealloc];
}
#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tableCell;
	
	NSMutableArray *section = ((NSMutableArray*)[eventSections objectAtIndex:indexPath.section]);
	Event *event = [section objectAtIndex:indexPath.row];
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
	df.dateFormat = @"MMMM d - hh:mm a";
	tableCell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
	UILabel *title;
	UILabel *date;
	if(!tableCell)
	{
		tableCell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(10, 5, 300, 40)] autorelease];
		tableCell.backgroundView.frame = CGRectMake(10, 5, 300, 40);
		tableCell.autoresizesSubviews = YES;
		tableCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		tableCell.backgroundColor = [UIColor clearColor];
//		UIImageView *backView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)] autorelease];
//		backView.backgroundColor = [UIColor whiteColor];
//		backView.image = [UIImage imageNamed:@"bar_portrait.png"];
//		backView.layer.cornerRadius = 5;
//		backView.clipsToBounds = YES;
//		backView.layer.shouldRasterize = YES;
//		backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		[tableCell.contentView addSubview:backView];
		if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
		{
			tableCell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"bar_portrait.png"]] autorelease];
		}
		else
		{
			tableCell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"bar_landscape.png"]] autorelease];
		}
		tableCell.backgroundView.contentMode = UIViewContentModeCenter;
		tableCell.tag = BAR_TAG;
		title = [[[UILabel alloc] initWithFrame:CGRectMake(40, 7, 220, 20)] autorelease];
		title.tag = LIST_CELL_TITLE;
//		title.backgroundColor = [UIColor clearColor];
		title.textAlignment = UITextAlignmentLeft;
		title.textColor = [UIColor darkGrayColor];
		title.font = [UIFont boldSystemFontOfSize:15];
		
		date = [[[UILabel alloc] initWithFrame:CGRectMake(40, 23, 220, 18)] autorelease];
		date.tag = LIST_CELL_DATE;
//		date.backgroundColor = [UIColor clearColor];
		date.textAlignment = UITextAlignmentLeft;
		date.textColor = [UIColor darkGrayColor];
		date.font = [UIFont systemFontOfSize:10];
		[tableCell.contentView addSubview:date];
		[tableCell.contentView addSubview:title];
		UIImageView *arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
		arrow.frame = CGRectMake(300-arrow.frame.size.width-10, 15, arrow.frame.size.width, arrow.frame.size.height);
		arrow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		arrow.contentMode = UIViewContentModeRight;
		[tableCell.contentView addSubview:arrow];
	}
	else
	{
		title = (UILabel*)[tableCell.contentView viewWithTag:LIST_CELL_TITLE];
		date = (UILabel*)[tableCell.contentView viewWithTag:LIST_CELL_DATE];
	}
	title.text = event.eventName;
	date.text = [df stringFromDate:event.eventDate];
	[df release];
	return tableCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//	NSArray *eventArray = [AttendanceList sharedAttendanceList].eventsArray;
//	for(NSMutableArray *array in eventSections)
//	{
//		[array removeAllObjects];
//	}
//	[eventSections removeAllObjects];
	[uniqueMonths removeAllObjects];
	for(Event *event in eventArray)
	{
		NSDate *date = event.eventDate;
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		df.dateFormat = @"yyyy-M/MM";
		if(![uniqueMonths containsObject:[df stringFromDate:date]])
		{
			[uniqueMonths addObject:[df stringFromDate:date]];
//			NSMutableArray *newSection = [[NSMutableArray alloc] init];
//			[eventSections addObject:newSection];
//			[newSection release];
		}
		[df release];
	}
	for(NSMutableArray *array in eventSections)
	{
		[array removeAllObjects];
//		[array release];
	}
	for(NSString *string in uniqueMonths)
	{
		[eventSections addObject:[[[NSMutableArray alloc] init] autorelease]];
	}
	return uniqueMonths.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	for(NSMutableArray *array in eventSections)
//	{
//		[array removeAllObjects];
//	}
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
