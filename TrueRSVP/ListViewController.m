//
//  AttendingViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "ListViewController.h"

@implementation ListViewController
@synthesize eventTableView;
@synthesize listController;
#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{

    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	eventTableView.delaysContentTouches = NO;
}
#pragma mark - Unloading
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
//	[eventTableView release];
//	[listController release];
	[super dealloc];
}
#pragma mark - View Delegate Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
	{
		self.eventTableView.frame = CGRectMake(0, 32, self.eventTableView.frame.size.width, self.eventTableView.frame.size.height);
		self.view.bounds = CGRectMake(0, 32, 480, 320);
	}
	else
	{
		self.eventTableView.frame = CGRectMake(0, 44, self.eventTableView.frame.size.width, self.eventTableView.frame.size.height);
		self.view.bounds = CGRectMake(0, 44, 320, 480);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 22;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)] autorelease];
	sectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OrangeBackground_1px.png"]];
	UILabel *label = [[[UILabel alloc] initWithFrame:sectionView.frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:15];
	if([UIDevice currentDevice].multitaskingSupported)
	{
		label.layer.shadowOpacity = 0.2;
		label.layer.shadowOffset = CGSizeMake(0.0, 2.0);
		label.layer.rasterizationScale = [[UIScreen mainScreen] scale];
		label.layer.shouldRasterize = YES;
	}
	NSString *selectedMonth = [listController.uniqueMonths objectAtIndex:section];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-M/MM";
	if([selectedMonth isEqualToString:[df stringFromDate:[NSDate date]]])
	{
		[label setText:@"   This Month"];
	}
	else
	{
		NSDate *fromString = [df dateFromString:selectedMonth];
		df.dateFormat = @"   MMMM";
		label.text = [df stringFromDate:fromString];
	}
	[sectionView addSubview: label];
	[df release];
	return sectionView;
}
@end
