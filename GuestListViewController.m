//
//  GuestListViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/27/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "GuestListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsManager.h"
#import "NSDictionary_JSONExtensions.h"
#import "CJSONDeserializer.h"
#import "ASIFormDataRequest.h"
@implementation GuestListViewController
@synthesize guestNameAttendance;
@synthesize event;
@synthesize eventName;
@synthesize eventDate;
@synthesize eventNameBack;
@synthesize eventCheckBack;
@synthesize eventCheck;
@synthesize guestTable;
@synthesize toolbar;
@synthesize searchButton;
@synthesize refreshButton;
@synthesize sendButton;
BOOL fnameAscending;
BOOL lnameAscending;
BOOL attendingAscending;
#pragma mark - Loading
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)thisEvent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		event = thisEvent;
		guestNameAttendance = [[NSMutableArray alloc] init];
		[self refreshGuestList];
		fnameAscending = YES;
		lnameAscending = YES;
		attendingAscending = YES;
		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
		searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 105, 48)];
		refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 0, 105, 48)];
		sendButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 0, 105, 48)];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	eventName.text = event.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:event.eventDate];
	[df release];
	guestTable.dataSource = self;
	guestTable.delegate = self;
	guestTable.backgroundColor = [UIColor clearColor];
	guestTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	eventNameBack.layer.cornerRadius = 5;
	eventNameBack.layer.shadowOffset = CGSizeMake(0.0, 0.2);
	eventNameBack.layer.shadowOpacity = 0.25;
	eventNameBack.layer.shouldRasterize = YES;
	
	eventCheckBack.layer.cornerRadius = 5;
	eventCheckBack.layer.shadowOffset = CGSizeMake(0.0, 0.2);
	eventCheckBack.layer.shadowOpacity = 0.25;
	eventCheckBack.layer.shouldRasterize = YES;	
	
	UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
	header.backgroundColor = [UIColor whiteColor];
	header.layer.cornerRadius = 5;
	UIView *masterHeader = [[[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 35)] autorelease];
	[masterHeader addSubview:header];
	masterHeader.clipsToBounds = YES;
	UIButton *firstNameButton = [[[UIButton alloc] initWithFrame:CGRectMake(15, 10, 85, 21)] autorelease];
	[firstNameButton setImage:[UIImage imageNamed:@"firstNameButton.png"] forState:UIControlStateNormal];
	[firstNameButton addTarget:self action:@selector(sortPressed:) forControlEvents:UIControlEventTouchUpInside];
	[header addSubview:firstNameButton];
	UIButton *lastNameButton = [[[UIButton alloc] initWithFrame:CGRectMake(110, 10, 85, 21)] autorelease];
	[lastNameButton setImage:[UIImage imageNamed:@"lastNameButton.png"] forState:UIControlStateNormal];
	[lastNameButton addTarget:self action:@selector(sortPressed:) forControlEvents:UIControlEventTouchUpInside];
	[header addSubview:lastNameButton];
	UIButton *attendedButton = [[[UIButton alloc] initWithFrame:CGRectMake(205, 10, 85, 21)] autorelease];
	[attendedButton setImage:[UIImage imageNamed:@"attendedButton.png"] forState:UIControlStateNormal];
	[attendedButton addTarget:self action:@selector(sortPressed:) forControlEvents:UIControlEventTouchUpInside];
	[header addSubview:attendedButton];
	[masterHeader sendSubviewToBack:header];
	UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, -5, 300, 15)] autorelease];
	footer.backgroundColor = [UIColor whiteColor];
	footer.layer.cornerRadius = 5;
	UIView *masterFooter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)] autorelease];
	masterFooter.bounds = CGRectMake(0, 5, 300, 20);
	masterFooter.clipsToBounds = YES;
	[masterFooter addSubview:footer];
	guestTable.tableHeaderView = masterHeader;
	guestTable.tableFooterView = masterFooter;
	
	guestTable.layer.shadowOffset = CGSizeMake(0.0, 0.3);
	guestTable.layer.shadowOpacity = 0.25;
	guestTable.layer.shouldRasterize = YES;
	guestTable.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	
	toolbar.barStyle = UIBarStyleBlack;
	[searchButton setImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
	[refreshButton setImage:[UIImage imageNamed:@"refreshButton.png"] forState:UIControlStateNormal];
	[sendButton setImage:[UIImage imageNamed:@"messageButton.png"] forState:UIControlStateNormal];
	[toolbar addSubview:searchButton];
	[toolbar addSubview:refreshButton];
	[toolbar addSubview:sendButton];
	[self.view addSubview:toolbar];
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
}
#pragma mark - Unloading
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)dealloc
{
	
	[eventName release];
	[eventDate release];
	[eventNameBack release];
	[guestTable release];
	[eventCheckBack release];
	[eventCheck release];
	[guestNameAttendance release];
	[toolbar release];
	[searchButton release];
	[refreshButton release];
	[sendButton release];
	[super dealloc];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)refreshGuestList
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager] APILocation], @"getGuestList"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:event.eventID forKey:@"eid"];
	[request startSynchronous];
	NSArray *guestNames = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil];
	for (NSDictionary *dictionary in guestNames)
	{
		Attendee *newAttendee = [[Attendee alloc] init];
		newAttendee.uid = [dictionary objectForKey:@"id"];
		newAttendee.fname = [dictionary objectForKey:@"fname"];
		newAttendee.lname = [dictionary objectForKey:@"lname"];
		newAttendee.isAttending = [[dictionary objectForKey:@"is_attending"] boolValue];
		[guestNameAttendance addObject:newAttendee];
		[newAttendee release];
	}
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - UIButton Actions
- (void)checkboxPressed:(UIButton*)sender
{
	if(sender.isSelected)
	{
		sender.selected = NO;
	}
	else
	{
		sender.selected = YES;
	}
	((Attendee*)[guestNameAttendance objectAtIndex:sender.tag]).isAttending = sender.selected;
}
- (void)sortPressed:(UIButton*)sender
{
	NSSortDescriptor *sortDescriptor;
	if([[sender imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"firstNameButton.png"]])
	{
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"fname" ascending:fnameAscending] autorelease];
		fnameAscending = !fnameAscending;
	}
	else if([[sender imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"lastNameButton.png"]])
	{
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lname" ascending: lnameAscending] autorelease];
		lnameAscending = !lnameAscending;
	}
	else
	{
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"isAttending" ascending:attendingAscending] autorelease];
		attendingAscending = !attendingAscending;
	}
		
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSMutableArray *sortedArray = [[NSMutableArray alloc] initWithArray:[guestNameAttendance sortedArrayUsingDescriptors:sortDescriptors] copyItems:YES];
	[guestNameAttendance release];
	guestNameAttendance = sortedArray;
	[guestTable reloadData];
}
#pragma mark - UITableView Methods
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 20;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *attendeeCell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, 20)] autorelease];
	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	backView.backgroundColor = [UIColor whiteColor];
	attendeeCell.backgroundView = backView;
	
	Attendee *attendee = ((Attendee*)[guestNameAttendance objectAtIndex:indexPath.row]);
	UILabel *fname = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 20)] autorelease];
	fname.text = [NSString stringWithString:attendee.fname];
	fname.textAlignment = UITextAlignmentLeft;
	fname.textColor = [UIColor blackColor];
	fname.font = [UIFont systemFontOfSize:12];
	[attendeeCell.contentView addSubview:fname];
	
	UILabel *lname = [[[UILabel alloc] initWithFrame:CGRectMake(120, 0, 60, 20)]autorelease];
	lname.text = [NSString stringWithString:attendee.lname];
	lname.textAlignment = UITextAlignmentCenter;
	lname.textColor = [UIColor blackColor];
	lname.font = [UIFont systemFontOfSize:12];
	[attendeeCell.contentView addSubview:lname];
	
	UIButton *checkbox = [[[UIButton alloc] initWithFrame:CGRectMake(240, 0, 16, 20)] autorelease];
	checkbox.tag = indexPath.row;
	[checkbox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
	[checkbox setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
	[checkbox addTarget:self action:@selector(checkboxPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	if(attendee.isAttending)
	{
		checkbox.selected = YES;
	}
	
	[attendeeCell.contentView addSubview:checkbox];
	return attendeeCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [guestNameAttendance count];
}

@end
