//
//  HostingViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "HostingViewController.h"

#import "User.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"

#import "HostingList.h"
#import "TrueRSVPAppDelegate.h"
@implementation HostingViewController
@synthesize hostingController;
@synthesize hostingDetailVC;
@synthesize delegate;

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		hostingController = [[HostingController alloc] init];
		listController = hostingController;
		hostingDetailVC = [[HostingDetailViewController alloc] initWithNibName:@"HostingDetailViewController" bundle:[NSBundle mainBundle]];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	eventTableView.dataSource = hostingController;
	eventTableView.delegate = self;
}
#pragma mark - Unloading

- (void)dealloc
{
	[hostingController release];
	[hostingDetailVC release];
	[super dealloc];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Event *event = [((NSMutableArray*)[hostingController.eventSections objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
	hostingDetailVC.eventHosting = event;
	[self.delegate selectedEvent:hostingDetailVC];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
