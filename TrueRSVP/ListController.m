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
		tableCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"] autorelease];
		tableCell.autoresizesSubviews = YES;
		tableCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		tableCell.backgroundColor = [UIColor clearColor];
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)] autorelease];
		backView.backgroundColor = [UIColor whiteColor];
		backView.layer.cornerRadius = 5;
		backView.clipsToBounds = YES;
		backView.layer.shouldRasterize = YES;
		backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[tableCell.contentView addSubview:backView];
		title = [[[UILabel alloc] initWithFrame:CGRectMake(40, 8, 220, 20)] autorelease];
		title.tag = LIST_CELL_TITLE;
		title.backgroundColor = [UIColor clearColor];
		title.textAlignment = UITextAlignmentLeft;
		title.textColor = [UIColor darkGrayColor];
		title.font = [UIFont boldSystemFontOfSize:15];
		[tableCell.contentView addSubview:title];
		
		date = [[[UILabel alloc] initWithFrame:CGRectMake(40, 24, 220, 20)] autorelease];
		date.tag = LIST_CELL_DATE;
		date.backgroundColor = [UIColor clearColor];
		date.textAlignment = UITextAlignmentLeft;
		date.textColor = [UIColor darkGrayColor];
		date.font = [UIFont systemFontOfSize:10];
		[tableCell.contentView addSubview:date];
		
		UIImageView *arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
		arrow.frame = CGRectMake(backView.frame.size.width-arrow.frame.size.width-10, 15, arrow.frame.size.width, arrow.frame.size.height);
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
		[eventSections addObject:[[NSMutableArray alloc] init]];
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
