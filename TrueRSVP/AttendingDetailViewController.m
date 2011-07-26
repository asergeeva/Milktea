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
#import "Constants.h"
#import "EventAnnotation.h"

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
- (IBAction)showMail:(id)sender
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@getOrganizerEmail", APILocation]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:[NSString stringWithFormat:@"%@", eventAttending.eventOrganizer] forKey:@"oid"];
	[request startSynchronous];
	MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
	mailVC.mailComposeDelegate = self;
	[mailVC setSubject:[NSString stringWithFormat:@"Event: %@",eventName.text]];
	NSDictionary *info = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSString *email = [info objectForKey:@"email"];
	[mailVC setToRecipients:[NSArray arrayWithObject:email]];
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
	[sheet release];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
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
		case 5:
			confidence = 1;
			break;
		default:
			return;
			break;
	}
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@setAttendanceForEvent", APILocation]]];
	[request setPostValue:[NSString stringWithFormat:@"%@", eventAttending.eventID] forKey:@"eid"];
	[request setPostValue:[NSString stringWithFormat:@"%d", confidence] forKey:@"confidence"];
	[request startSynchronous];
//	NSLog(@"%@", [request responseString]);
}
- (void)viewWillAppear:(BOOL)animated
{
	eventName.text = eventAttending.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:eventAttending.eventDate];
	eventDescription.text = eventAttending.eventDescription;
	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventAttending.eventAddress];
	NSURL *someURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:someURL];
	[request startSynchronous];
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
	[df release];
	[self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[super viewWillAppear:animated];
}
- (void)viewDidLoad
{

    [super viewDidLoad];
	//self.view.frame = self.navigationController.view.frame;
	
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		eventWhiteBack.frame = CGRectMake(5, 55, 165, 40);
		buttonWhiteBack.frame = CGRectMake(5, 105, 165, 195);
		eventDescriptionWhiteBack.frame = CGRectMake(175, 55, 300, 243);
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
