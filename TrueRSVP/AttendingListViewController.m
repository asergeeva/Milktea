//
//  AttendingViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AttendingListViewController.h"

#import "User.h"
//#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "CJSONDeserializer.h"
#import "AttendanceList.h"
#import "TrueRSVPAppDelegate.h"
#import "LocationManager.h"
@implementation AttendingListViewController
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
//	[eventTableView release];
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
- (void)checkIfAttending:(ASIHTTPRequest*)request
{
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	if(![[dictionary objectForKey:@"is_attending"] isEqual:@"1"])
	{
		//for(Event *event in attendingController.eventArray)
		for(int i = 0; i < attendingController.eventArray.count; i++)
		{
			Event *event = [attendingController.eventArray objectAtIndex:i];
			if([event.eventID isEqual:[dictionary objectForKey:@"event_id"]])
			{
				[[LocationManager sharedLocationManager] addEvent:event];
				break;
			}
		}
	}
//	[[NetworkManager sharedNetworkManager] refreshAllWithDelegate:self completion:@selector(stopLoading)];

}
- (void)doneRefresh
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd";
	for(Event *event in attendingController.eventArray)
	{
		if([[df stringFromDate:event.eventDate] isEqual:[df stringFromDate:[NSDate date]]])
		{
			[[NetworkManager sharedNetworkManager] isCheckedInWithEID:event.eventID didFinish:@selector(checkIfAttending:) delegate:self];
		}
	}
	[df release];
	[self stopLoading];
}
- (void)refresh
{
//	NSArray *attendanceInfo = [NetworkManager sharedNetworkManager].attendingList;
//	[[AttendanceList sharedAttendanceList] updateEventsList:attendanceInfo];
//	attendingController.eventArray = [AttendanceList sharedAttendanceList].eventsArray;
	[[NetworkManager sharedNetworkManager] refreshAllWithDelegate:self completion:@selector(doneRefresh)];
}
@end
