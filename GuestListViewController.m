//
//  GuestListViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/27/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "Constants.h"
#import "GuestListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsManager.h"
#import "NetworkManager.h"
#import "NSDictionary_JSONExtensions.h"
#import "CJSONDeserializer.h"
#import "ASIFormDataRequest.h"
#import "CheckInButton.h"
#import "SendButton.h"
#import "MessageViewController.h"
#import "QueuedActions.h"
@implementation GuestListViewController
@synthesize guestNameAttendance;
@synthesize event;
//@synthesize eventName;
//@synthesize eventDate;
//@synthesize eventNameBack;
//@synthesize eventCheckBack;
//@synthesize eventCheck;
//@synthesize guestTable;
@synthesize toolbar;
@synthesize toolbar2;
@synthesize searchButton;
@synthesize refreshButton;
@synthesize sendButton;
@synthesize doneButton;
@synthesize masterHeader;
@synthesize searchHeader;
@synthesize searchBar;
@synthesize filteredArray;
@synthesize showMessages;
//@synthesize selectionList;
//@synthesize scale;
BOOL fnameAscending;
BOOL lnameAscending;
BOOL attendingAscending;
BOOL sendSelection = NO;
#pragma mark - Loading
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)thisEvent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		event = thisEvent;
		guestNameAttendance = [[NSMutableArray alloc] init];
		fnameAscending = YES;
		lnameAscending = YES;
		attendingAscending = YES;
		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
		searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 105, 48)];
		refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(105, 0, 105, 48)];
		[refreshButton addTarget:self action:@selector(refreshGuestList) forControlEvents:UIControlEventTouchUpInside];
		sendButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 0, 105, 48)];
		doneButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 44)];
		searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 210, 44)];
		filteredArray = [[NSMutableArray alloc] init];
		selectionList = [[NSMutableArray alloc] init];
		showMessages = NO;
    }
    return self;
}
- (void)addEffects:(UIView*)view
{
	view.layer.cornerRadius = 5;
	view.layer.shadowOpacity = 0.3;
	view.layer.shadowOffset = CGSizeMake(0.0, 0.1);
	view.layer.shadowRadius = 1;
	view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	view.layer.shouldRasterize = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
	if(sendSelection)
	{
		[self backButtonPressed];
	}
}
- (void)viewDidAppear:(BOOL)animated
{
	if(showMessages)
	{
		[self sendPressed:nil];
	}
	[super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"Guest List";
	eventName.text = event.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:event.eventDate];
	[df release];
	
	guestTable.dataSource = self;
	guestTable.delegate = self;
	guestTable.backgroundColor = [UIColor clearColor];
	guestTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	guestTable.tag = TABLE_TAG;

	
	UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
	header.backgroundColor = [UIColor whiteColor];
	masterHeader = [[[UIView alloc] initWithFrame:CGRectMake(10, 145, 300, 35)] autorelease];
	searchHeader = [[[UIView alloc] initWithFrame:CGRectMake(10, 145, 300, 35)] autorelease];
	[masterHeader addSubview:header];
	[masterHeader sendSubviewToBack:header];
	masterHeader.tag = HEADER_TAG;
	if([UIDevice currentDevice].multitaskingSupported)
	{
		header.layer.cornerRadius = 5;
		[self addEffects:eventNameBack];
		[self addEffects:eventCheckBack];
		[self addEffects:guestTable];
		[self addEffects:masterHeader];
	}
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
	[doneButton setImage:[UIImage imageNamed: @"doneButton.png"] forState:UIControlStateNormal];
	doneButton.backgroundColor = [UIColor whiteColor];
	[doneButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
	
	searchBar.delegate = self;
	searchBar.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
	searchBar.layer.borderWidth = 1;
	searchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
	searchBar.layer.shadowOpacity = 0;
	
	for(UIView *view in [searchBar subviews])
	{
		if([view isKindOfClass:[UITextField class]])
		{
			UITextField *temp = (UITextField*)view;
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:temp];	
			break;
		}
	}
	
	[searchHeader addSubview:searchBar];
	[searchHeader addSubview:doneButton];
	[searchHeader sendSubviewToBack:doneButton];
	[self moveSearchOut:0];
	
	toolbar.barStyle = UIBarStyleBlack;
	[searchButton setImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
	[searchButton addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[refreshButton setImage:[UIImage imageNamed:@"refreshButton.png"] forState:UIControlStateNormal];
	[sendButton setImage:[UIImage imageNamed:@"messageButton.png"] forState:UIControlStateNormal];
	[toolbar addSubview:searchButton];
	[toolbar addSubview:refreshButton];
	[toolbar addSubview:sendButton];
	toolbar.tag = TOOLBAR_TAG;
	
	[sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:masterHeader];
	[self.view addSubview:searchHeader];
	[self.view addSubview:toolbar];
	
	searchHeader.hidden = YES;
	
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
	[self refreshGuestList];
//	toolbar.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
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
//	[navBar release];
	[guestNameAttendance release];
	[toolbar release];
	[toolbar2 release];
	[searchButton release];
	[refreshButton release];
	[sendButton release];
	[masterHeader release];
	[searchHeader release];
	[searchBar release];
	[selectionList release];
//	[scale release];
	[super dealloc];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)refreshGuestList
{
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"], @"getGuestList"]];
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//	[request addPostValue:event.eventID forKey:@"eid"];
//	[request startSynchronous];
//	NSArray *guestNames = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil];
	NSArray *guestNames = [[NetworkManager sharedNetworkManager].guestList objectForKey:event.eventID];
	[guestNameAttendance removeAllObjects];
//	for (NSDictionary *dictionary in guestNames)
//	{
//		Attendee *newAttendee = [[Attendee alloc] init];
//		newAttendee.uid = [dictionary objectForKey:@"id"];
//		//if(((NSString*)[dictionary objectForKey:@"fname"]) != [NSNull null])
//		if((NSString*)[dictionary objectForKey:@"fname"])
//			newAttendee.fname = [dictionary objectForKey:@"fname"];
//		else
//			newAttendee.fname = @" ";
//		if([dictionary objectForKey:@"lname"] != [NSNull null])
//			newAttendee.lname = [dictionary objectForKey:@"lname"];
//		else
//			newAttendee.lname = @" ";
//		newAttendee.isAttending = [[dictionary objectForKey:@"is_attending"] boolValue];
//		[guestNameAttendance addObject:newAttendee];
//		[newAttendee release];
//	}
	[guestNameAttendance addObjectsFromArray:guestNames];
	[guestTable reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		return NO;
}
- (void)moveSearchOut:(float)duration
{
	[UIView animateWithDuration:duration animations:^(void) {
		CGRect rect = searchHeader.frame;
		rect.origin.x -= 400;
		searchHeader.frame = rect;
		searchHeader.layer.opacity = 0.0;
	}];
}
#pragma mark - UIButton Actions
- (void)checkboxPressed:(CheckInButton*)sender
{
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@checkIn",[[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"]]];

//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//	[request setPostValue:sender.uid forKey:@"uid"];
//	[request setPostValue:sender.eid forKey:@"eid"];
	NSString *checkInValue;
	if(sender.isSelected)
	{
//		[request setPostValue:@"0" forKey:@"checkIn"];
		checkInValue = @"0";
		sender.selected = NO;
	}
	else
	{
//		[request setPostValue:@"1" forKey:@"checkIn"];
		checkInValue = @"1";
		sender.selected = YES;
	}
//	[request startSynchronous];
	ASIHTTPRequest *request = [[NetworkManager sharedNetworkManager] checkInWithEID:sender.eid uid:sender.uid checkInValue:checkInValue];
	((Attendee*)[guestNameAttendance objectAtIndex:sender.tag]).isAttending = sender.selected;
	if([request error])
	{
		[[QueuedActions sharedQueuedActions] addActionWithEID:sender.eid userID:sender.uid attendance:sender.selected date:[NSDate date]];
	}
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
-(void)searchPressed:(UIButton*)sender
{
	searchHeader.hidden = NO;
	[searchBar becomeFirstResponder];
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect rect = masterHeader.frame;
		rect.origin.x += 400;
		masterHeader.frame = rect;
		
		rect = searchHeader.frame;
		rect.origin.x += 400;
		searchHeader.frame = rect;
		
		rect = self.view.frame;
		rect.origin.y -= 95;
		self.view.frame = rect;
		
		rect = self.navigationController.view.frame;
		rect.origin.y -= 44;
		self.navigationController.view.frame = rect;
		
		rect = guestTable.frame;
		rect.origin.y -= 11;
		guestTable.frame = rect;
		searchHeader.layer.opacity = 1.0;
	}];
	[self.view bringSubviewToFront:guestTable];
}
- (void)donePressed:(UISearchBar *)thisSearchBar
{
	[searchBar resignFirstResponder];
	[self moveSearchOut:0.3];
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect rect = masterHeader.frame;
		rect.origin.x -= 400;
		masterHeader.frame = rect;
		
		rect = self.view.frame;
		rect.origin.y += 95;
		self.view.frame = rect;
		
		rect = self.navigationController.view.frame;
		rect.origin.y += 44;
		self.navigationController.view.frame = rect;
		
		rect = guestTable.frame;
		rect.origin.y += 11;
		guestTable.frame = rect;	
	}];
	
	[guestTable reloadData];
	searchBar.text = @"";
	[self.view bringSubviewToFront:toolbar];
}
- (void)selectAllPressed
{
	[selectionList removeAllObjects];
	for(Attendee *attendee in guestNameAttendance)
	{
		[selectionList addObject:attendee.uid];
	}
	[guestTable reloadData];
}
- (void)selectNonePressed
{
	[selectionList removeAllObjects];
	[guestTable reloadData];	
}
- (void)backButtonPressed
{
	sendSelection = NO;
	[selectionList removeAllObjects];
	[guestTable reloadData];
	[UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationCurveEaseOut animations:^(void) {
		for(UIView *view in self.view.subviews)
		{
			if(view.tag == TOOLBAR_TAG)
			{
				CGRect rect = view.frame;
				rect.origin.y -= 480;
				view.frame = rect;
			}
			else if(view.tag == HEADER_TAG)
			{
				CGRect rect = view.frame;
				rect.origin.y = 145;
				view.frame = rect;					
			}
			else if(view.tag == TOOLBAR2_TAG)
			{
				CGRect rect = view.frame;
				rect.origin.y += 80;
				view.frame = rect;				
			}
			else if(view.tag != TABLE_TAG)
			{
				CGRect rect = view.frame;
				rect.origin.y += 244;
				view.frame = rect;					
			}

		}
	}completion:^(BOOL finished) {
		if(finished)
		{
			[toolbar2 removeFromSuperview];
			[toolbar2 release];
		}
	}];
	[UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationCurveEaseIn animations:^(void) {
		CGRect rect = guestTable.frame;
		rect.origin.y = 195;
		rect.size.height = 362;
		guestTable.frame = rect;	
		[sendButton removeFromSuperview];
		[toolbar addSubview:sendButton];	
		rect = self.view.bounds;
		rect.origin.y += 44;
		self.view.bounds = rect;
	} completion:^(BOOL finished) {
		[sendButton removeTarget:self action:@selector(sendPressed2) forControlEvents:UIControlEventTouchUpInside];
		[sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
	}];
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
}
- (void)sendPressed2
{
	if(selectionList.count > 0)
	{
		[self.navigationController setNavigationBarHidden:NO animated:YES];	
		MessageViewController *messageVC = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:[NSBundle mainBundle] list:selectionList event:event];
		[self.navigationController pushViewController:messageVC animated:YES];
		[messageVC release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Guest List" 
														message:@"Please select at least one person to contact."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	showMessages = NO;
}
- (void)sendPressed:(UIButton*)sender
{
	sendSelection = YES;
	self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.914 green:0.902 blue:0.863 alpha:1.000];
//	[searchButton setImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
//	[searchButton addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^(void) {
		for(UIView *view in self.view.subviews)
		{
			if(view.tag == TOOLBAR_TAG)
			{
				CGRect rect = view.frame;
				rect.origin.y += 480;
				view.frame = rect;
			}
			else if(view.tag == HEADER_TAG)
			{
				CGRect rect = view.frame;
				rect.origin.y = 10;
				view.frame = rect;					
			}
			else if(view.tag != TABLE_TAG && view.tag != TOOLBAR2_TAG)
			{

				CGRect rect = view.frame;
				rect.origin.y -= 244;
				view.frame = rect;					
			}
		}
	}completion:nil];
	
	toolbar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 516, 320, 44)];
	toolbar2.barStyle = UIBarStyleBlack;
	toolbar2.tag = TOOLBAR2_TAG;
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(4, -2, 49, 49)];
	[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	UIButton *selectNone = [[UIButton alloc] initWithFrame:CGRectMake(70, -2, 63, 49)];
	[selectNone setImage:[UIImage imageNamed:@"selectNone.png"] forState:UIControlStateNormal];
	[selectNone addTarget:self action:@selector(selectNonePressed) forControlEvents:UIControlEventTouchUpInside];
	UIButton *selectAll = [[UIButton alloc] initWithFrame:CGRectMake(155, -2, 49, 49)];
	[selectAll setImage:[UIImage imageNamed:@"selectAll.png"] forState:UIControlStateNormal];
	[selectAll addTarget:self action:@selector(selectAllPressed)forControlEvents:UIControlEventTouchUpInside];
	[toolbar2 addSubview:backButton];
	[toolbar2 addSubview:selectAll];
	[toolbar2 addSubview:selectNone];
	[backButton release];
	[selectAll release];
	[selectNone release];
	[self.view addSubview:toolbar2];
	toolbar2.alpha = 0;
	[sendButton removeTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
	[sendButton addTarget:self action:@selector(sendPressed2) forControlEvents:UIControlEventTouchUpInside];
	[UIView animateWithDuration:0.75 delay:0.05 options:UIViewAnimationCurveEaseInOut animations:^(void) {
		[sendButton removeFromSuperview];
		[toolbar2 addSubview:sendButton];
		CGRect rect = guestTable.frame;
		rect.origin.y = 54;
		rect.size.height = self.view.frame.size.height;
		guestTable.frame = rect;		
		rect = self.view.bounds;
		rect.origin.y = 0;
		self.view.bounds = rect;
		toolbar2.alpha = 1;
		rect = toolbar2.frame;
		rect.origin.y -= 100;
		toolbar2.frame = rect;
	} completion:nil];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark - UITableView Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
	if(sendSelection)
	{
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		for (UIView *view in [currentCell.contentView subviews])
		{
			if([view isKindOfClass:[SendButton class]])
			{
				SendButton *tempButton = (SendButton*)view;
				if(tempButton.selected)
				{
					tempButton.selected = NO;
					[selectionList removeObject:tempButton.uid];
				}
				else
				{
					tempButton.selected = YES;
					[selectionList addObject:tempButton.uid];
				}
				return;
			}
		}
	}
	else
	{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		for (UIView *view in [currentCell.contentView subviews])
		{
			if([view isKindOfClass:[CheckInButton class]])
			{
				[self checkboxPressed:(CheckInButton*)view];
				return;
			}
		}
	}

}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *attendeeCell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, 20)] autorelease];
	attendeeCell.autoresizingMask = UIViewAutoresizingNone;
	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	backView.backgroundColor = [UIColor whiteColor];
	attendeeCell.backgroundView = backView;
	
	Attendee *attendee;
	if([searchBar isFirstResponder] && searchBar.text.length != 0)
	{
		attendee = ((Attendee*)[filteredArray objectAtIndex:indexPath.row]);		
	}
	else
	{
		attendee = ((Attendee*)[guestNameAttendance objectAtIndex:indexPath.row]);
	}
	SendButton *sendMarker = [[[SendButton alloc] initWithFrame:CGRectMake(2, 7, 17, 17)] autorelease];
	sendMarker.tag = 5555;
	[sendMarker setImage:[UIImage imageNamed:@"sendMarker.png"] forState:UIControlStateSelected];
	sendMarker.uid = attendee.uid;
	[attendeeCell.contentView addSubview:sendMarker];
	
	if([selectionList containsObject:attendee.uid])
	{
		sendMarker.selected = YES;	
	}
	
	UILabel *fname = [[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 20)] autorelease];
	fname.text = [NSString stringWithString:attendee.fname];
	fname.textAlignment = UITextAlignmentLeft;
	fname.textColor = [UIColor blackColor];
	fname.font = [UIFont systemFontOfSize:12];
	[attendeeCell.contentView addSubview:fname];
	
	UILabel *lname = [[[UILabel alloc] initWithFrame:CGRectMake(120, 5, 60, 20)]autorelease];
	lname.text = [NSString stringWithString:attendee.lname];
	lname.textAlignment = UITextAlignmentCenter;
	lname.textColor = [UIColor blackColor];
	lname.font = [UIFont systemFontOfSize:12];
	[attendeeCell.contentView addSubview:lname];
	
	CheckInButton *checkbox = [[[CheckInButton alloc] initWithFrame:CGRectMake(240, 5, 16, 20)] autorelease];
	checkbox.tag = indexPath.row;
	[checkbox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
	[checkbox setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
	[checkbox addTarget:self action:@selector(checkboxPressed:) forControlEvents:UIControlEventTouchUpInside];
	checkbox.uid = attendee.uid;
	checkbox.eid = event.eventID;
	checkbox.userInteractionEnabled = NO;
	if(attendee.isAttending)
	{
		checkbox.selected = YES;
	}
	
	[attendeeCell.contentView addSubview:checkbox];
	return attendeeCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if([searchBar isFirstResponder] && searchBar.text.length != 0)
	{
		return [filteredArray count];		
	}
	return [guestNameAttendance count];
}
#pragma - Text Field Delegate Methods
- (void)textFieldDidChange:(NSNotification*)bar
{
	[filteredArray removeAllObjects];
	UISearchBar *objSearchBar = ((UISearchBar*)bar.object);
//	if(objSearchBar.text.length == 0)
//	{
//		return;
//	}
	NSArray *searchTerms = [objSearchBar.text componentsSeparatedByString:@" "];
	for (NSString *term in searchTerms)
	{
		for (Attendee *attendee in guestNameAttendance)
		{
			if([[attendee.fname lowercaseString] hasPrefix:[term lowercaseString]] || [[attendee.lname lowercaseString] hasPrefix:[term lowercaseString]])
			{
				if(![filteredArray containsObject:attendee])
				{	
					[filteredArray addObject:attendee];
				}
			}
		}
	}
	[guestTable reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[filteredArray removeAllObjects];
	if(searchText.length == 0)
	{
		return;
	}
	for (Attendee *attendee in guestNameAttendance)
	{
		if([attendee.fname hasPrefix:searchText])
		{
			[filteredArray addObject:attendee];
		}
	}
}
@end
