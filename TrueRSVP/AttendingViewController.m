//
//  AttendingViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AttendingViewController.h"

#import "User.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"

#import "AttendanceList.h"
#import "TrueRSVPAppDelegate.h"
@implementation AttendingViewController
@synthesize attendingController;
@synthesize attendingDetailVC;
@synthesize delegate;
#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		attendingController = [[AttendingController alloc] init];
		listController = attendingController;
		attendingDetailVC = [[AttendingDetailViewController alloc] initWithNibName:@"AttendingDetailViewController" bundle:[NSBundle mainBundle]];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	eventTableView.dataSource = attendingController;
	eventTableView.delegate = self;
}
- (void)dealloc
{
	[attendingController release];
	[attendingDetailVC release];
	[super dealloc];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Event *event = [((NSMutableArray*)[attendingController.eventSections objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
	attendingDetailVC.eventAttending = event;
	[self.delegate selectedEvent:attendingDetailVC];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
