//
//  HostingDetailViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "HostingDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "EventAnnotation.h"
#import "SettingsManager.h"
#import "LiveViewController.h"
#import "QueuedActions.h"
#import "NetworkManager.h"
@implementation HostingDetailViewController
@synthesize eventHosting;
//@synthesize dynamicRSVP;
//@synthesize staticRSVP;
@synthesize yourRSVPBack;
@synthesize eventWhiteBack;
@synthesize eventMapBack;
//@synthesize eventName;
//@synthesize eventDate;
@synthesize eventDescriptionWhiteBack;
@synthesize eventDescription;
@synthesize eventMap;
//@synthesize contact;
//@synthesize checkIn;
//@synthesize live;
//@synthesize lat;
//@synthesize lng;
//@synthesize buttonWhiteBack;
@synthesize guestListVC;
@synthesize reader;

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//		eventHosting = event;
		reader = [ZBarReaderViewController new];
		reader.readerDelegate = self;
		reader.showsZBarControls = NO;
		[reader.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
		[reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[NetworkManager sharedNetworkManager] getMapWithAddress:eventHosting.eventAddress delegate:self finishedSelector:@selector(mapRequestFinished:) failedSelector:@selector(mapRequestFailed:)];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
}
- (void)viewDidDisappear:(BOOL)animated
{
	eventMap.alpha = 0;
	eventMap.hidden = YES;
//	eventAddress.alpha = 0;
//	eventAddress.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
//	[[NetworkManager sharedNetworkManager] getMapWithAddress:eventHosting.eventAddress delegate:self finishedSelector:@selector(mapRequestFinished:) failedSelector:@selector(mapRequestFailed:)];


	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	eventName.text = eventHosting.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:eventHosting.eventDate];
	eventDescription.text = [NSString stringWithFormat:@"%@\n%@", eventHosting.eventDescription, eventHosting.eventAddress];
	[df release];
	[[NetworkManager sharedNetworkManager] getScoreWithEID:eventHosting.eventID delegate:self finishedSelector:@selector(scoreLoadFinished:) failedSelector:@selector(scoreLoadFailed:)];
	QRData.text = @"";
}
- (void)addShadows:(UIView*)view
{
	view.layer.shadowOpacity = 0.3;
	view.layer.shadowOffset = CGSizeMake(0.0, 0.1);
	view.layer.shadowRadius = 1;
	view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	view.layer.shouldRasterize = YES;
}
- (void)addEffects:(UIView*)view
{
	view.layer.cornerRadius = 5;
	[self addShadows:view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	eventMap.alpha = 0;
	eventMap.hidden = YES;
//	eventAddress.alpha = 0;
//	eventAddress.hidden = YES;
	self.navigationItem.title = @"Event Details";
    // Do any additional setup after loading the view from its nib.
	if([UIDevice currentDevice].multitaskingSupported)
	{
		[self addEffects:eventWhiteBack];
		[self addEffects:eventMapBack];
		[self addEffects:eventDescriptionWhiteBack];
//		[self addEffects:buttonWhiteBack];
		[self addEffects:yourRSVPBack];
//		[self addEffects:eventMap];
		[self addShadows:contact];
		[contact setBackgroundImage:[UIImage imageNamed:@"bar_portrait.png"] forState:UIControlStateNormal];
		contact.backgroundColor = [UIColor clearColor];
		[self addShadows:checkIn];
		[checkIn setBackgroundImage:[UIImage imageNamed:@"bar_portrait.png"] forState:UIControlStateNormal];
		checkIn.backgroundColor = [UIColor clearColor];
		[self addShadows:discuss];
		[discuss setBackgroundImage:[UIImage imageNamed:@"bar_portrait.png"] forState:UIControlStateNormal];
		discuss.backgroundColor = [UIColor clearColor];
	}
//	contact.layer.cornerRadius = 5;
//	contact.clipsToBounds = YES;
//	checkIn.layer.cornerRadius = 5;
//	checkIn.clipsToBounds = YES;
//	live.layer.cornerRadius = 5;
//	live.clipsToBounds = YES;

	eventMap.mapType = MKMapTypeStandard;
	eventMap.zoomEnabled = YES;
	eventMap.scrollEnabled = YES;
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
	eventMap.frame = CGRectMake(25, 275, 270, 72);
	eventDescription.frame = CGRectMake(17, 157, 292, 116);
	
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 450, 320, 30)] autorelease];
	view.backgroundColor = [UIColor whiteColor];
	UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 70, 30)];
	QRData = [[UILabel alloc] initWithFrame:CGRectMake(70, 1, 250, 30)];
	[doneButton setImage:[UIImage imageNamed:@"doneButton.png"] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(dismissCamera) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:doneButton];
	[view addSubview:QRData];
	[doneButton release];
	reader.cameraOverlayView = view;

}
#pragma mark - Unload
- (void)viewDidUnload
{
//	[eventHosting release];
//	eventHosting = nil;
	[eventDescriptionWhiteBack release];
	eventDescriptionWhiteBack = nil;
//	[eventName release];
//	eventName = nil;
//	[eventDate release];
//	eventDate = nil;
//	[eventDescription release];
//	eventDescription = nil;
	[eventMap release];
	eventMap = nil;
	[eventMapBack release];
	eventMapBack = nil;
	[contact release];
	contact = nil;
	[checkIn release];
	checkIn = nil;
//	[live release];
//	live = nil;
//	[buttonWhiteBack release];
//	buttonWhiteBack = nil;
//	[yourRSVPBack release];
//	yourRSVPBack = nil;
	[staticRSVP release];
	staticRSVP = nil;
//	[dynamicRSVP release];
//	dynamicRSVP = nil;
//	[guestListVC release];
//	guestListVC = nil;
//	[reader release];
//	reader = nil;

//	[eventAddress release];
//	eventAddress = nil;
	[checkInArrow release];
	checkInArrow = nil;
	[contactArrow release];
	contactArrow = nil;
	[discussArrow release];
	discussArrow = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[eventHosting release];
	[eventDescriptionWhiteBack release];
	[eventName release];
	[eventDate release];
	[eventDescription release];
	[eventMap release];
	[eventMapBack release];
	[contact release];
	[checkIn release];
	[discuss release];
//	[buttonWhiteBack release];
	[yourRSVPBack release];
	[staticRSVP release];
	[dynamicRSVP release];
	[guestListVC release];
	[reader release];
	[QRData release];
//	[eventAddress release];
	[checkInArrow release];
	[contactArrow release];
	[discussArrow release];
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
	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
	{
		CGFloat topMargin = 10.0;
		eventWhiteBack.frame = CGRectMake(10, 51 + topMargin, 290, 40);
		eventName.frame = CGRectMake(20, 54 + topMargin, 270, 21);
		eventDate.frame = CGRectMake(20, 71 + topMargin, 270, 21);
		
		yourRSVPBack.frame = CGRectMake(310, 51 + topMargin, 162, 40);
		staticRSVP.frame = CGRectMake(327, 59 + topMargin, 120, 21);
		dynamicRSVP.frame = CGRectMake(430, 59 + topMargin, 30, 21);
		
		eventMapBack.frame = CGRectMake(10, 100 + topMargin, 290, 143);
		eventMap.frame = CGRectMake(20, 109 + topMargin, 270, 126);
		
		eventDescriptionWhiteBack.frame = CGRectMake(310, 100 + topMargin, 160, 143);
		eventDescription.frame = CGRectMake(320, 110 + topMargin, 135, 123);
		
		checkIn.frame = CGRectMake(10, 251 + topMargin, 150, 40);
		checkIn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		checkInArrow.hidden = YES;
		contact.frame = CGRectMake(320, 251 + topMargin, 150, 40);
		contact.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		contactArrow.hidden = YES;
		discuss.frame = CGRectMake(165, 251 + topMargin, 150, 40);
		discuss.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		discussArrow.hidden = YES;	
	}
	else
	{
		eventWhiteBack.frame = CGRectMake(10, 54, 300, 40);
		eventName.frame = CGRectMake(20, 57, 280, 21);
		eventDate.frame = CGRectMake(20, 74, 280, 21);
		
		yourRSVPBack.frame = CGRectMake(10, 105, 300, 30);
		staticRSVP.frame = CGRectMake(10, 109, 300, 21);
		dynamicRSVP.frame = CGRectMake(198, 109, 30, 21);
		
		eventMap.frame = CGRectMake(25, 223, 270, 80);
		eventMapBack.frame = CGRectMake(500, 500, 300, 114);
	
		checkIn.frame = CGRectMake(10, 331, 300, 35);
		checkIn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
//		checkInArrow.frame = CGRectMake(280, 340, 12, 18);
		checkInArrow.hidden = NO;
		contact.frame = CGRectMake(10, 415, 300, 35);
		contact.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
//		contactArrow.frame = CGRectMake(280, 340, 12, 18);
		contactArrow.hidden = NO;
		discuss.frame = CGRectMake(10, 374, 300, 35);
		discuss.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
//		discussArrow.frame = CGRectMake(280, 426, 12, 18);
		discussArrow.hidden = NO;
		
		eventDescriptionWhiteBack.frame = CGRectMake(10, 143, 300, 180);
		eventDescription.frame = CGRectMake(16, 158, 286, 61);
//		self.view.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - ASIHTTP Delegate Methods
- (void)mapRequestFinished:(ASIHTTPRequest *)request
{
	eventMap.hidden = NO;
	[UIView animateWithDuration:0.3 animations:^(void) {
		eventMap.alpha = 1.0;
	}];
	NSDictionary *result = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSDictionary *location = [[[[result objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
	lat = [[location objectForKey:@"lat"] floatValue];
	lng = [[location objectForKey:@"lng"] floatValue];
	CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
	MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
	MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
	eventMap.region = region;
	[eventMap removeAnnotations:[eventMap annotations]];
	EventAnnotation *annotation = [[EventAnnotation alloc] initWithName:eventName.text coordinate:coord];
	[eventMap addAnnotation:annotation];
	[annotation release];
}
- (void)mapRequestFailed:(ASIHTTPRequest *)request
{
//	eventAddress.text = eventHosting.eventAddress;
//	eventAddress.hidden = NO;
//	[UIView animateWithDuration:0.3 animations:^(void) {
//		eventAddress.alpha = 1.0;
//	}];
//	NSLog(@"Loading Map failed");	
}
- (void)scoreLoadFinished:(ASIHTTPRequest*)request
{
	dynamicRSVP.text = [request responseString];
}
- (void)scoreLoadFailed:(ASIHTTPRequest*)request
{
	NSLog(@"Loading TrueRSVP score failed");
}
#pragma mark - Button Methods
- (IBAction)messagePressed:(UIButton*)sender
{
	[FlurryAnalytics logEvent:@"HOSTING_DETAIL_MESSAGING_INITIATED"];
	guestListVC = [[GuestListViewController alloc] initWithNibName:@"GuestListViewController" bundle:[NSBundle mainBundle] event:eventHosting];
	guestListVC.showMessages = YES;
//	if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//	{
//		UIViewController *vc = [[[UIViewController alloc] init] autorelease];
//		[self presentModalViewController:vc animated:NO];
//		[self dismissModalViewControllerAnimated:NO];
//	}	
	[self.navigationController pushViewController:guestListVC animated:YES];
}
- (IBAction)showLive:(UIButton*)sender
{
	LiveViewController *liveVC = [[[LiveViewController alloc] initWithNibName:@"LiveViewController" bundle:[NSBundle mainBundle] event:eventHosting] autorelease];
	[self.navigationController pushViewController:liveVC animated:YES];
	
}
- (IBAction)showCheckIn:(id)sender
{
	UIActionSheet *sheet;
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{	
		sheet = [[UIActionSheet alloc] initWithTitle:@"Check In" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Guest List", @"QR Code Reader", nil];
	}
	else
	{
		sheet = [[UIActionSheet alloc] initWithTitle:@"Check In" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Check in via Guest List", nil];		
	}
	[sheet showInView:self.view];
	[sheet release];
}
- (void)dismissCamera
{
	[self dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
	NSMutableString *result = [[NSMutableString alloc] init];
	for(ZBarSymbol *symbol in results)
	{
		NSArray *splitString = [((NSString*)symbol.data) componentsSeparatedByString:@"-"];
		if(splitString.count != 3)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid QR Code" message:@"This QR code is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else if(![[splitString objectAtIndex:1] isEqualToString:eventHosting.eventID])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid QR Code" message:@"This QR code is for another event!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{			
			if(![[NetworkManager sharedNetworkManager] isOnline])
			{
				[[QueuedActions sharedQueuedActions] addActionWithEID:[splitString objectAtIndex:1] userID:[splitString objectAtIndex:2] attendance:YES date:[NSDate date]];
				[result setString: @"Queued checkin for next push"];
			}
			else
			{
				[[NetworkManager sharedNetworkManager] checkInWithEID:[splitString objectAtIndex:1] uid:[splitString objectAtIndex:2] checkInValue:@"1"];	
				[result setString:[NSString stringWithFormat: @"Checked in:%@", [[NetworkManager sharedNetworkManager] getUsernameWithUID:[splitString objectAtIndex:2]]]];	
			}
		}
	}
	[reader dismissModalViewControllerAnimated:NO];
	[self presentModalViewController:reader animated:NO];
	QRData.text = result;
	[result release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
			guestListVC = [[GuestListViewController alloc] initWithNibName:@"GuestListViewController" bundle:[NSBundle mainBundle] event:eventHosting];
//			if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//			{
//				//				[self presentModalViewController:guestListVC animated:YES];
//				UIViewController *vc = [[[UIViewController alloc] init] autorelease];
//				[self presentModalViewController:vc animated:NO];
//				[self dismissModalViewControllerAnimated:NO];
//			}	
			[self.navigationController pushViewController:guestListVC animated:YES];
			break;
		case 1:
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
			{
				
				[[UIApplication sharedApplication] setStatusBarHidden:YES];
				[self presentModalViewController:reader animated:YES];
			}
			break;
		default:
			return;
			break;
	}
}
@end
