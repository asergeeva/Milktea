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

#import "Attendance.h"
#import <QuartzCore/QuartzCore.h>
#import "TrueRSVPAppDelegate.h"
@implementation AttendingViewController
@synthesize eventTableView;
@synthesize attendingController;
//@synthesize uniqueMonths;
//@synthesize eventSections;
@synthesize delegate;
#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		attendingController = [[AttendingController alloc] init];
        // Custom initialization
//		uniqueMonths = [[NSMutableArray alloc] init];
//		eventSections = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

	eventTableView.dataSource = attendingController;
	eventTableView.delegate = self;
	eventTableView.delaysContentTouches = NO;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Unloading
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
//	[uniqueMonths release];
	[eventTableView release];
	[attendingController release];
	[super dealloc];
}
#pragma mark - View Delegate Methods
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
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	EventAttending *event = [((NSMutableArray*)[attendingController.eventSections objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
	AttendingDetailViewController *attendingDetailVC = [[AttendingDetailViewController alloc] initWithNibName:@"AttendingDetailViewController" bundle:[NSBundle mainBundle] event:event];
	[self.delegate selectedEvent:attendingDetailVC];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	[((TrueRSVPAppDelegate*)[UIApplication sharedApplication]).navController pushViewController:attendingDetailVC animated:YES];
	//	self.view = attendingDetailVC.view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 22;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)] autorelease];
	sectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OrangeBackground_1px.png"]];
	UILabel *label = [[UILabel alloc] initWithFrame:sectionView.frame];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:15];
	label.layer.shadowOpacity = 0.2;
	label.layer.shadowOffset = CGSizeMake(0.0, 2.0);
	label.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	label.layer.shouldRasterize = YES;
	NSString *selectedMonth = [attendingController.uniqueMonths objectAtIndex:section];
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
@end
