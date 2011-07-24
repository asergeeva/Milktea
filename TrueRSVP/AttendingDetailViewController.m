//
//  AttendingDetailViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/23/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AttendingDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"

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
//@synthesize address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(EventAttending*)event
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
- (IBAction)showMail:(id)sender
{
	MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
	mailVC.mailComposeDelegate = self;
	[mailVC setSubject:[NSString stringWithFormat:@"Event: %@",eventName.text]];
	[self presentModalViewController:mailVC animated:YES];
	[mailVC release];
}
- (IBAction)showMap:(id)sender
{
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?ll=%f,%f", lat, lng]];
	NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", eventAttending.eventAddress] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	[[UIApplication sharedApplication] openURL:url];
}
- (IBAction)showRSVP:(id)sender
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Update RSVP" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes, I'll absolutely be there", @"I'm Pretty sure I'll be there", @"I'll go unless my plans change", @"I probably can't go", @"No, but I'm a supporter", @"No, I'm not interested", nil];
	[sheet showInView:self.view];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
	eventName.text = eventAttending.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:eventAttending.eventDate];
	eventDescription.text = eventAttending.eventDescription;
//	[address setString:eventAttending.eventAddress];
    [super viewDidLoad];
//	self.navigationController.navigationBarHidden = YES;
	self.view.frame = self.navigationController.view.frame;
	eventMap.mapType = MKMapTypeStandard;
	eventMap.zoomEnabled = YES;
	eventMap.scrollEnabled = YES;
	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventAttending.eventAddress];
	NSURL *someURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:someURL];
	[request startSynchronous];
	NSDictionary *result = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSDictionary *location = [[[[result objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
	lat = [[location objectForKey:@"lat"] floatValue];
	lng = [[location objectForKey:@"lng"] floatValue];
	CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
//	CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(60, -149);
	MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
	MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
	eventMap.region = region;
//	[eventMap setCenterCoordinate:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]) animated:YES];
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
	[self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
//    // Do any additional setup after loading the view from its nib.
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
		eventWhiteBack.frame = CGRectMake(5, 81, 165, 40);
		eventName.frame = CGRectMake(12, 84, 150, 21);
		eventDate.frame = CGRectMake(12, 99, 150, 21);
		eventDescriptionWhiteBack.frame = CGRectMake(175, 80, 300, 200);
		eventDescription.frame = CGRectMake(15, 10, 270, 60);
		eventMap.frame = CGRectMake(15, 83, 270, 110);
		contact.frame = CGRectMake(29, 225, 125, 23);
		directions.frame = CGRectMake(29, 256, 125, 23);
		update.frame = CGRectMake(6, 128, 165, 24);
		checkIn.frame = CGRectMake(6, 161, 165, 24);
		live.frame = CGRectMake(6, 193, 165, 24);
		self.view.frame = CGRectMake(-2.0, 10.0, 480.0, 320.0);
	}
	else
	{
		eventWhiteBack.frame = CGRectMake(10, 55, 300, 40);
		eventName.frame = CGRectMake(20, 58, 280, 21);
		eventDate.frame = CGRectMake(20, 75, 280, 21);
		eventDescriptionWhiteBack.frame = CGRectMake(10, 103, 300, 200);
		eventDescription.frame = CGRectMake(15, 10, 270, 60);
		eventMap.frame = CGRectMake(15, 83, 270, 75);
		contact.frame = CGRectMake(25, 267, 125, 23);
		directions.frame = CGRectMake(170, 267, 125, 23);
		update.frame = CGRectMake(70, 329, 180, 27);
		checkIn.frame = CGRectMake(70, 364, 180, 27);
		live.frame = CGRectMake(70, 399, 180, 27);
		self.view.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

@end
