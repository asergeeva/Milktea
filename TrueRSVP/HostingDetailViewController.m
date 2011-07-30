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
@synthesize buttonWhiteBack;
@synthesize guestListVC;
@synthesize reader;
#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		eventHosting = event;
		reader = [ZBarReaderViewController new];
		reader.readerDelegate = self;
		reader.showsZBarControls = NO;
		[reader.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
		[reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	NSString *urlAddress = [NSString stringWithFormat:@"%@computeTrueRSVP", [[SettingsManager sharedSettingsManager] APILocation]];
	NSURL *trueURL = [NSURL URLWithString:urlAddress];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:trueURL];
	[request setPostValue:eventHosting.eventID forKey:@"eid"];
	[request startSynchronous];
	dynamicRSVP.text = [request responseString];
	
	urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventHosting.eventAddress];
	NSURL *mapURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	ASIHTTPRequest *requestMap = [ASIHTTPRequest requestWithURL:mapURL];
	requestMap.delegate = self;
	[requestMap startAsynchronous];

	[super viewWillAppear:animated];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"Event Details";
    // Do any additional setup after loading the view from its nib.
	CGSize shadowOffset = CGSizeMake(0.0, 0.2);
	eventWhiteBack.layer.cornerRadius = 5;
	eventWhiteBack.layer.shadowOpacity = 0.3;
	eventWhiteBack.layer.shadowOffset = shadowOffset;
	eventWhiteBack.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	eventWhiteBack.layer.shouldRasterize = YES;
	eventDescriptionWhiteBack.layer.cornerRadius = 5;
	eventDescriptionWhiteBack.layer.shadowOpacity = 0.3;
	eventDescriptionWhiteBack.layer.shadowOffset = shadowOffset;
	eventDescriptionWhiteBack.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	eventDescriptionWhiteBack.layer.shouldRasterize = YES;
	buttonWhiteBack.layer.cornerRadius = 5;
	buttonWhiteBack.layer.shadowOpacity = 0.3;
	buttonWhiteBack.layer.shadowOffset = shadowOffset;
	buttonWhiteBack.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	buttonWhiteBack.layer.shouldRasterize = YES;
	yourRSVPBack.layer.cornerRadius = 5;
	yourRSVPBack.layer.shadowOpacity = 0.3;
	yourRSVPBack.layer.shadowOffset = shadowOffset;
	yourRSVPBack.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	yourRSVPBack.layer.shouldRasterize = YES;
		
	contact.layer.cornerRadius = 5;
	contact.clipsToBounds = YES;
	checkIn.layer.cornerRadius = 5;
	checkIn.clipsToBounds = YES;
	live.layer.cornerRadius = 5;
	live.clipsToBounds = YES;

	eventName.text = eventHosting.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:eventHosting.eventDate];
	eventDescription.text = eventHosting.eventDescription;
	[df release];
	
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
	[buttonWhiteBack release];
	buttonWhiteBack = nil;
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
	[live release];
	[buttonWhiteBack release];
	[yourRSVPBack release];
	[staticRSVP release];
	[dynamicRSVP release];
	[guestListVC release];
	[reader release];
	[QRData release];
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
		eventWhiteBack.frame = CGRectMake(0, 51, 300, 40);
		eventName.frame = CGRectMake(10, 54, 380, 21);
		eventDate.frame = CGRectMake(10, 71, 280, 21);
		yourRSVPBack.frame = CGRectMake(308, 51, 172, 40);
		staticRSVP.frame = CGRectMake(247, 59, 300, 21);
		dynamicRSVP.frame = CGRectMake(0, 500, 94, 21);
		eventMap.frame = CGRectMake(8, 109, 284, 96);
		eventMapBack.frame = CGRectMake(0, 100, 300, 114);
		buttonWhiteBack.frame = CGRectMake(308, 100, 172, 114);
		live.frame = CGRectMake(319, 177, 150, 27);
		contact.frame = CGRectMake(319, 143, 150, 27);
		checkIn.frame = CGRectMake(319, 109, 150, 27);
		eventDescriptionWhiteBack.frame = CGRectMake(0, 222, 480, 72);
		eventDescription.frame = CGRectMake(15, 0, 455, 72);
	}
	else
	{
		eventWhiteBack.frame = CGRectMake(10, 54, 300, 40);
		eventName.frame = CGRectMake(20, 57, 280, 21);
		eventDate.frame = CGRectMake(20, 74, 280, 21);
		yourRSVPBack.frame = CGRectMake(10, 105, 300, 40);
		staticRSVP.frame = CGRectMake(10, 114, 300, 21);
		dynamicRSVP.frame = CGRectMake(198,114, 94, 21);
		eventMap.frame = CGRectMake(25, 235, 270, 72);
		eventMapBack.frame = CGRectMake(500, 500, 300, 114);
		buttonWhiteBack.frame = CGRectMake(55, 325, 210, 120);
		live.frame = CGRectMake(70, 407, 180, 27);
		contact.frame = CGRectMake(70, 372, 180, 27);
		checkIn.frame = CGRectMake(70, 337, 180, 27);
		eventDescriptionWhiteBack.frame = CGRectMake(10, 153, 300, 164);
		eventDescription.frame = CGRectMake(0, 0, 300, 76);
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
- (void)requestFinished:(ASIHTTPRequest *)request
{
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
#pragma mark - Button Methods
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
	for(ZBarSymbol *symbol in results)
	{
		QRData.text = symbol.data;
	}
	[reader dismissModalViewControllerAnimated:NO];
	[self presentModalViewController:reader animated:NO];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
			guestListVC = [[GuestListViewController alloc] initWithNibName:@"GuestListViewController" bundle:[NSBundle mainBundle] event:eventHosting];
			if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
			{
				//				[self presentModalViewController:guestListVC animated:YES];
				UIViewController *vc = [[UIViewController alloc] init];
				[self presentModalViewController:vc animated:NO];
				[self dismissModalViewControllerAnimated:NO];
			}	
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
