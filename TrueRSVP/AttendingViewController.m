//
//  AttendingViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AttendingViewController.h"
#import "AttendingDetailViewController.h"
#import "User.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "NSDictionary_JSONExtensions.h"
#import "Attendance.h"
#import <QuartzCore/QuartzCore.h>
#import "TrueRSVPAppDelegate.h"
@implementation AttendingViewController
@synthesize eventTableView;
@synthesize uniqueMonths;
@synthesize eventSections;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		uniqueMonths = [[NSMutableArray alloc] init];
		eventSections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	EventAttending *event = [((NSMutableArray*)[eventSections objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
	AttendingDetailViewController *attendingDetailVC = [[AttendingDetailViewController alloc] initWithNibName:@"AttendingDetailViewController" bundle:[NSBundle mainBundle] event:event];
	[self.delegate selectedEvent:attendingDetailVC];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	[((TrueRSVPAppDelegate*)[UIApplication sharedApplication]).navController pushViewController:attendingDetailVC animated:YES];
	//	self.view = attendingDetailVC.view;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"someCell"];
	if(tableCell == nil)
	{
		tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"someCell"];		
		tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		tableCell.textLabel.font = [UIFont systemFontOfSize:14];
		tableCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
		tableCell.detailTextLabel.textColor = [UIColor grayColor];
	}

//	EventAttending *event = ((EventAttending*)[[Attendance sharedAttendance].eventsArray objectAtIndex:indexPath.section + indexPath.row]);		
	EventAttending *event = [((NSMutableArray*)[eventSections objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
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
	NSArray *eventArray = [Attendance sharedAttendance].eventsArray;
	for(EventAttending *event in eventArray)
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
	NSArray *eventArray = [Attendance sharedAttendance].eventsArray;
	int counter = 0;
	for(EventAttending *event in eventArray)
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 22;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)] autorelease];
	sectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Attending_1px.png"]];
	UILabel *label = [[UILabel alloc] initWithFrame:sectionView.frame];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:15];
	label.layer.shadowOpacity = 0.2;
	label.layer.shadowOffset = CGSizeMake(0.0, 2.0);
	label.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	label.layer.shouldRasterize = YES;
	NSString *selectedMonth = [uniqueMonths objectAtIndex:section];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-M/MM";
	if([selectedMonth isEqualToString:[df stringFromDate:[NSDate date]]])
	{
		label.text = @"   This Month";
	}
	else
	{
		NSDate *fromString = [df dateFromString:selectedMonth];
		df.dateFormat = @"   MMMM";
		label.text = [df stringFromDate:fromString];
	}
	[sectionView addSubview: label];
	[label release];
	return sectionView;
}
- (void)refreshAttendance
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APILocation, @"getAttendingEvents/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	NSArray *attendanceInfo = [NSDictionary dictionaryWithJSONString:[request responseString] error:nil];
	[[Attendance sharedAttendance] updateAttendance:attendanceInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self refreshAttendance];
	eventTableView.dataSource = self;
	eventTableView.delegate = self;
	eventTableView.delaysContentTouches = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
//	{
//		self.view.frame = CGRectMake(480.0, 0.0, 480.0, 320.0);
//	}
//	else
//	{
//		self.view.frame = CGRectMake(320.0, 0.0, 320.0, 480.0);
//	}
//	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)dealloc
{
	[uniqueMonths release];
	[eventTableView release];
	[super dealloc];
}
@end
