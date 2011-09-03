//
//  RSVPViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 9/3/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "RSVPViewController.h"
#import "CheckInButton.h"
#import "Constants.h"
#import "Event.h"
#import "NetworkManager.h"
#import <QuartzCore/QuartzCore.h>
#import "RSVPCell.h"
@implementation RSVPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		choices = [[NSArray alloc] initWithObjects:@"Absolutely", @"Pretty Sure", @"50/50", @"Most Likely Not", @"Raincheck", nil];
		confidenceLevels = [[NSArray alloc] initWithObjects:@"90", @"65", @"35", @"15", @"4", nil];
		checkboxes = [[NSMutableArray alloc] initWithCapacity:5];
		confidence = -1;
		_event = event;
		if([[NetworkManager sharedNetworkManager] isOnline])
		{
			confidence = [[NetworkManager sharedNetworkManager] getAttendanceForEvent:event.eventID];
		}
		eid = event.eventID;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSString*)selectedConfidence:(int)confidenceSelected
{
//	NSString *prefix = @"Your current selected RSVP: ";
	NSString *selection;
	switch (confidenceSelected) {
		case 90:
			selection = @"Absolutely";
			break;
		case 65:
			selection = @"Pretty Sure";
			break;				
		case 35:
			selection = @"50/50";
			break;
		case 15:
			selection = @"Most Likely Not";
			break;
		case 4:
			selection = @"Raincheck";
			break;
		default:
			selection = @"N/A";
			break;
	}
	confidence = confidenceSelected;
	return selection;
}
- (void)selectConfidence:(int)value
{
	switch (value) {
		case 0:
			confidence = 90;
			break;
		case 1:
			confidence = 65;
			break;
		case 2:
			confidence = 35;
			break;
		case 3:
			confidence = 15;
			break;
		case 4:
			confidence = 4;
		default:
			break;
	}
	[[NetworkManager sharedNetworkManager] setAttendanceWithEID:eid confidence:[NSString stringWithFormat:@"%i",confidence]];
	currentRSVP.text = [NSString stringWithFormat:@"Your current RSVP: %@", [self selectedConfidence:confidence]];
//	[self selectedConfidence];
}
- (void)addEffects:(UIView*)view
{
	view.layer.cornerRadius = 5;
//	view.layer.shadowOpacity = 0.3;
//	view.layer.shadowOffset = CGSizeMake(0.0, 0.1);
//	view.layer.shadowRadius = 1;
	view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	view.layer.shouldRasterize = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:spacer];
	[spacer release];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, self.view.frame.size.width, 21.0f)];
	[titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setTextColor:[UIColor whiteColor]];
	titleLabel.contentMode = UIViewContentModeCenter;
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[titleLabel setText:@"Select your RSVP"];
	[titleLabel setTextAlignment:UITextAlignmentCenter];

	UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
	[items addObject:title];
	[title release];
	[titleLabel release];
	
	UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:spacer2];
	[spacer2 release];
	

	[selectToolbar setItems:items animated:YES];
	[items release];
	
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	rsvpTable.delegate = self;
	rsvpTable.dataSource = self;
	rsvpTable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self addEffects:rsvpTable];
	rsvpTable.layer.masksToBounds = YES;
	[self addEffects:eventBack];
	[self addEffects:rsvpBack];
//	[self selectedConfidence];
	selectToolbar.tintColor = [UIColor colorWithRed:0.235 green:0.600 blue:0.792 alpha:1.000];
	eventTitle.text = _event.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:_event.eventDate];
	[df release];
	eventBack.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	rsvpBack.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	rsvpTable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	currentRSVP.text = [NSString stringWithFormat:@"Your current RSVP: %@", [self selectedConfidence:[[NetworkManager sharedNetworkManager] getAttendanceForEvent:eid]]];
	currentRSVP.contentMode = UIViewContentModeCenter;
	currentRSVP.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // Do any additional setup after loading the view from its nib.
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		rsvpTable.frame = CGRectMake(10, 118, 460, 100);
	}
	else
	{
		rsvpTable.frame = CGRectMake(10, 118, 300, 200);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}
- (void)viewDidUnload
{
	[eventTitle release];
	eventTitle = nil;
    [eventDate release];
    eventDate = nil;
    [currentRSVP release];
    currentRSVP = nil;
	[rsvpTable release];
	rsvpTable = nil;
	[eventBack release];
	eventBack = nil;
	[rsvpBack release];
	rsvpBack = nil;
	[selectToolbar release];
	selectToolbar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [eventTitle release];
    [eventDate release];
    [currentRSVP release];
	[rsvpTable release];
	[choices release];
	[checkboxes release];
	[eventBack release];
	[rsvpBack release];
	[selectToolbar release];
    [super dealloc];
}
- (void)checkboxPressed:(int)conf
{
	for(CheckInButton* button in checkboxes)	
	{
		button.on = NO;
		[button setSelected: NO];
		if(button.value == conf)
		{
			button.on = YES;
			[button setSelected: YES];
		}
	}

	[self selectConfidence:conf];
}
#pragma mark - Table Methods
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UILabel *fname = [[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 220, 20)] autorelease];
	fname.text = [choices objectAtIndex:indexPath.row];
	fname.textAlignment = UITextAlignmentLeft;
	fname.textColor = [UIColor blackColor];
	fname.font = [UIFont systemFontOfSize:17];
	
	RSVPCell *rsvpCell = [[[RSVPCell alloc] init] autorelease];
	rsvpCell.frame = CGRectMake(0, 0, 300, 20);
	rsvpCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	backView.backgroundColor = [UIColor whiteColor];
	
	rsvpCell.backgroundView = backView;
	
	CheckInButton *checkbox = [[[CheckInButton alloc] initWithFrame:CGRectMake(240, 5, 20, 20)] autorelease];
	[checkbox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
	[checkbox setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
	checkbox.userInteractionEnabled = NO;
	checkbox.tag = GUEST_CHECKBOX;
	checkbox.contentMode = UIViewContentModeRight;
	checkbox.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	checkbox.value = indexPath.row;
	[checkboxes addObject:checkbox];
	rsvpCell.confidence = indexPath.row;
	[rsvpCell.contentView addSubview:fname];
	[rsvpCell.contentView addSubview:checkbox];
	return rsvpCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}
- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	RSVPCell *cell = (RSVPCell*)[tableView cellForRowAtIndexPath:indexPath];
	[self checkboxPressed:cell.confidence];
}
@end
