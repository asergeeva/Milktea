//
//  AttendingDetailViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/23/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AttendingDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import <QuartzCore/QuartzCore.h>
//#import "Constants.h"
#import "SettingsManager.h"
#import "EventAnnotation.h"
#import "LiveViewController.h"
#import "NetworkManager.h"
#import "MiscHelper.h"
@implementation AttendingDetailViewController
@synthesize eventAttending;
@synthesize eventWhiteBack;
@synthesize eventName;
@synthesize eventDate;
@synthesize eventDescriptionWhiteBack;
@synthesize eventDescription;
@synthesize eventMap;
@synthesize contact;
@synthesize directions;
@synthesize update;
@synthesize checkIn;
@synthesize live;
@synthesize lat;
@synthesize lng;
@synthesize buttonWhiteBack;
@synthesize organizerEmail;
//@synthesize address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		eventAttending = event;
		[eventAttending retain];
//		address = [[NSMutableString alloc] init];
    }
    return self;
}
- (IBAction)showLive:(UIButton*)sender
{
	LiveViewController *liveVC = [[[LiveViewController alloc] initWithNibName:@"LiveViewController" bundle:[NSBundle mainBundle] event:eventAttending] autorelease];
	[self.navigationController pushViewController:liveVC animated:YES];
	
}
- (IBAction)showMail:(UIButton*)sender
{

	MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
	mailVC.mailComposeDelegate = self;
	[mailVC setSubject:[NSString stringWithFormat:@"Event: %@",eventName.text]];
	ASIHTTPRequest *request = [[NetworkManager sharedNetworkManager] getOrganizerEmailForOrganizerID:eventAttending.eventOrganizer];
	NSDictionary *info = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSString *email = [info objectForKey:@"email"];
	if(![request error])
	{
		[mailVC setToRecipients:[NSArray arrayWithObject:email]];
		[self presentModalViewController:mailVC animated:YES];
		[mailVC release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect" message:@"Could not find the e-mail address for the organizer. Try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}
- (IBAction)showMap:(UIButton*)sender
{
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?ll=%f,%f", lat, lng]];
	NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", eventAttending.eventAddress] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	[[UIApplication sharedApplication] openURL:url];
}
- (IBAction)showRSVP:(UIButton*)sender
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Update RSVP" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Absolutely", @"Pretty Sure", @"50/50", @"Most Likely Not", @"Raincheck", nil];
	[sheet showInView:self.view];
	[sheet release];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)checkIn:(UIButton*)sender
{
	CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
	CLLocationDistance distance = [destinationLocation distanceFromLocation:eventMap.userLocation.location];
	if(distance > 3218)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
														message:@"You are either too far or GPS is currently inaccurate. Try again when you are closer to the event."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		[[NetworkManager sharedNetworkManager] checkInWithEID:eventAttending.eventID];
//		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@checkInByDistance",[[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"]]];
//		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//		[request setPostValue:eventAttending.eventID forKey:@"eid"];
//		[request startSynchronous];
//		if([[request responseString] isEqualToString:@"status_checkInSuccess"])
//		{
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
//															message:@"You are now checked in!"
//														   delegate:nil
//												  cancelButtonTitle:@"OK" 
//												  otherButtonTitles:nil];
//			[alert show];
//			[alert release];
//		}
//		else
//		{
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
//															message:@"Check-in unsuccessful. Try again later."
//														   delegate:nil
//												  cancelButtonTitle:@"OK" 
//												  otherButtonTitles:nil];
//			[alert show];
//			[alert release];
//		}
	}
	[destinationLocation release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	int confidence = 0;
	switch (buttonIndex)
	{
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
			break;
//		case 5:
//			confidence = 1;
//			break;
		default:
			return;
			break;
	}

	[[NetworkManager sharedNetworkManager] setAttendanceWithEID:eventAttending.eventID confidence:[NSString stringWithFormat:@"%d", confidence]];
//	NSLog(@"%@", [request responseString]);
}
- (void)viewWillAppear:(BOOL)animated
{
//	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventAttending.eventAddress];
//	NSURL *someURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
//	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:someURL];
//	request.delegate = self;
//	[request startAsynchronous];
	[[NetworkManager sharedNetworkManager] getMapWithAddress:eventAttending.eventAddress delegate:self];
	[super viewWillAppear:animated];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];

//	directions.enabled = NO;
	eventName.text = eventAttending.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:eventAttending.eventDate];
	eventDescription.text = eventAttending.eventDescription;
	[df release];
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
- (void)viewDidLoad
{

    [super viewDidLoad];
	//self.view.frame = self.navigationController.view.frame;
	self.navigationItem.title = @"Event Details";
	if([UIDevice currentDevice].multitaskingSupported)
	{
		[self addEffects:eventWhiteBack];
		[self addEffects:eventDescriptionWhiteBack];
		[self addEffects:buttonWhiteBack];
		[self addEffects:eventMap];
	}
	contact.layer.cornerRadius = 5;
	contact.clipsToBounds = YES;
	directions.layer.cornerRadius = 5;
	directions.clipsToBounds = YES;
	update.layer.cornerRadius = 5;
	update.clipsToBounds = YES;
	checkIn.layer.cornerRadius = 5;
	checkIn.clipsToBounds = YES;
	live.layer.cornerRadius = 5;
	live.clipsToBounds = YES;
	

	
	eventMap.mapType = MKMapTypeStandard;
	eventMap.zoomEnabled = YES;
	eventMap.scrollEnabled = YES;
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[eventAttending release];
	[eventDescriptionWhiteBack release];
	[eventName release];
	[eventDate release];
	[eventDescriptionWhiteBack release];
	[eventDescription release];
	[eventMap release];
	[contact release];
	[directions release];
	[update release];
	[checkIn release];
	[live release];
	[buttonWhiteBack release];
	[organizerEmail release];
//	[someURL release];
//	[address release];
	[super dealloc];
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
	NSDictionary *result = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSDictionary *location = [[[[result objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
	lat = [[location objectForKey:@"lat"] floatValue];
	lng = [[location objectForKey:@"lng"] floatValue];
	CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
//	CLLocationCoordinate2D coord = [MiscHelper getCoordsFromAddressRequest:request];
	MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
	MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
	eventMap.region = region;
	[eventMap removeAnnotations:[eventMap annotations]];
	EventAnnotation *annotation = [[EventAnnotation alloc] initWithName:eventName.text coordinate:coord];
	[eventMap addAnnotation:annotation];
	[annotation release];
//	directions.enabled = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		eventWhiteBack.frame = CGRectMake(5, 55, 165, 40);
		buttonWhiteBack.frame = CGRectMake(5, 105, 165, 195);
		eventDescriptionWhiteBack.frame = CGRectMake(175, 55, 300, 245);
		eventName.frame = CGRectMake(12, 55, 150, 21);
		eventDate.frame = CGRectMake(12, 74, 150, 21);
		eventDescription.frame = CGRectMake(15, 5, 270, 80);
		eventMap.frame = CGRectMake(15, 110, 270, 120);
		
		update.frame = CGRectMake(12, 115, 150, 24);
		checkIn.frame = CGRectMake(12, 153, 150, 24);
		live.frame = CGRectMake(12, 191, 150, 24);
		contact.frame = CGRectMake(12, 229, 150, 23);
		directions.frame = CGRectMake(12, 267, 150, 23);

//		self.view.frame = CGRectMake(-2.0, 10.0, 480.0, 320.0);
	}
	else
	{
		eventWhiteBack.frame = CGRectMake(10, 55, 300, 40);
		buttonWhiteBack.frame = CGRectMake(45, 311, 230, 135);
		eventDescriptionWhiteBack.frame = CGRectMake(10, 103, 300, 200);
		eventName.frame = CGRectMake(20, 58, 280, 21);
		eventDate.frame = CGRectMake(20, 75, 280, 21);
		eventDescription.frame = CGRectMake(15, 10, 270, 60);
		eventMap.frame = CGRectMake(15, 83, 270, 75);
		update.frame = CGRectMake(70, 329, 180, 27);
		checkIn.frame = CGRectMake(70, 364, 180, 27);
		contact.frame = CGRectMake(25, 267, 125, 23);
		live.frame = CGRectMake(70, 399, 180, 27);
		directions.frame = CGRectMake(170, 267, 125, 23);

		self.view.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

@end
