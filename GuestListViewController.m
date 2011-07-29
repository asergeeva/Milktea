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
//@synthesize navBar;
@synthesize eventNameBack;
@synthesize eventCheckBack;
@synthesize eventCheck;
@synthesize guestTable;
@synthesize toolbar;
@synthesize searchButton;
@synthesize refreshButton;
@synthesize sendButton;
@synthesize doneButton;
@synthesize masterHeader;
@synthesize searchHeader;
@synthesize searchBar;
@synthesize filteredArray;
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
		doneButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 44)];
		searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 210, 44)];
		filteredArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//	navBar.hidden = YES;
//	if(self.parentViewController.modalViewController == self)
//	{
//		navBar.hidden = NO;
//	}
	self.navigationItem.title = @"Guest List";
	eventName.text = event.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:event.eventDate];
	[df release];
	
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	guestTable.dataSource = self;
	guestTable.delegate = self;
	guestTable.backgroundColor = [UIColor clearColor];
	guestTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	eventNameBack.layer.cornerRadius = 5;
	eventNameBack.layer.shadowOffset = CGSizeMake(0.0, 0.2);
	eventNameBack.layer.shadowOpacity = 0.25;
	eventNameBack.layer.shouldRasterize = YES;
	eventNameBack.layer.rasterizationScale = scale;
	
	eventCheckBack.layer.cornerRadius = 5;
	eventCheckBack.layer.shadowOffset = CGSizeMake(0.0, 0.2);
	eventCheckBack.layer.shadowOpacity = 0.25;
	eventCheckBack.layer.shouldRasterize = YES;	
	eventCheckBack.layer.rasterizationScale = scale;
	UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
	header.backgroundColor = [UIColor whiteColor];
	header.layer.cornerRadius = 5;
	masterHeader = [[[UIView alloc] initWithFrame:CGRectMake(10, 145, 300, 35)] autorelease];
	searchHeader = [[[UIView alloc] initWithFrame:CGRectMake(10, 145, 300, 35)] autorelease];
	[masterHeader addSubview:header];
	[masterHeader sendSubviewToBack:header];
	masterHeader.layer.cornerRadius = 5;
	masterHeader.layer.shadowOffset = CGSizeMake(0.0, 0.2);
	masterHeader.layer.shadowOpacity = 0.25;
	masterHeader.layer.shouldRasterize = YES;	
	masterHeader.layer.rasterizationScale = scale;

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
//			temp.returnKeyType = UIReturnKeyDone;
//			[temp addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:temp];	
			
			break;
		}
	}
	[searchHeader addSubview:searchBar];
	[searchHeader addSubview:doneButton];
	[searchHeader sendSubviewToBack:doneButton];
	[self moveSearchOut:0];
	guestTable.layer.shadowOffset = CGSizeMake(0.0, 0.3);
	guestTable.layer.shadowOpacity = 0.25;
	guestTable.layer.shouldRasterize = YES;
	guestTable.layer.rasterizationScale = scale;
	guestTable.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	
	toolbar.barStyle = UIBarStyleBlack;
	[searchButton setImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
	[searchButton addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
	[refreshButton setImage:[UIImage imageNamed:@"refreshButton.png"] forState:UIControlStateNormal];
	[sendButton setImage:[UIImage imageNamed:@"messageButton.png"] forState:UIControlStateNormal];
	[toolbar addSubview:searchButton];
	[toolbar addSubview:refreshButton];
	[toolbar addSubview:sendButton];
	
	[self.view addSubview:masterHeader];
	[self.view addSubview:searchHeader];
	[self.view addSubview:toolbar];
	
	searchHeader.hidden = YES;
	
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
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
	[searchButton release];
	[refreshButton release];
	[sendButton release];
	[masterHeader release];
	[searchHeader release];
	[searchBar release];
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
		return NO;
}
- (void)moveSearchOut:(float)duration
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationBeginsFromCurrentState:YES];
	
	CGRect rect = searchHeader.frame;
	rect.origin.x -= 400;
	searchHeader.frame = rect;
	searchHeader.layer.opacity = 0.0;
	[UIView commitAnimations];
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
-(void)searchPressed:(UIButton*)sender
{
	searchHeader.hidden = NO;
	[searchBar becomeFirstResponder];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
	
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
	[UIView commitAnimations];
	[self.view bringSubviewToFront:guestTable];
}
- (void)donePressed:(UISearchBar *)thisSearchBar
{
	[searchBar resignFirstResponder];
	[self moveSearchOut:0.3];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
	
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
	
	[UIView commitAnimations];
	
	[guestTable reloadData];
	searchBar.text = @"";
	[self.view bringSubviewToFront:toolbar];
}
#pragma mark - UITableView Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 20;
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
