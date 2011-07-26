//
//  HostingDetailViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "HostingDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "EventAnnotation.h"
@implementation HostingDetailViewController
@synthesize eventHosting;
@synthesize dynamicRSVP;
@synthesize staticRSVP;
@synthesize yourRSVPBack;
@synthesize eventWhiteBack;
@synthesize eventName;
@synthesize eventDate;
@synthesize eventDescriptionWhiteBack;
@synthesize eventDescription;
@synthesize eventMap;
@synthesize contact;
@synthesize checkIn;
@synthesize live;
@synthesize lat;
@synthesize lng;
@synthesize buttonWhiteBack;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		eventHosting = event;
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
- (void)viewWillAppear:(BOOL)animated
{
	eventName.text = eventHosting.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:eventHosting.eventDate];
	eventDescription.text = eventHosting.eventDescription;
	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventHosting.eventAddress];
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

	eventMap.mapType = MKMapTypeStandard;
	eventMap.zoomEnabled = YES;
	eventMap.scrollEnabled = YES;
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
}

- (void)viewDidUnload
{
//	[eventHosting release];
//	eventHosting = nil;
//	[eventName release];
//	eventName = nil;
//	[eventDate release];
//	eventDate = nil;
//	[eventDescriptionWhiteBack release];
//	eventDescriptionWhiteBack = nil;
//	[eventDescription release];
//	eventDescription = nil;
//	[eventMap release];
//	eventMap = nil;
//	[contact release];
//	contact = nil;
//	[checkIn release];
//	checkIn = nil;
//	[live release];
//	live = nil;
//	[yourRSVPBack release];
//	yourRSVPBack = nil;
//	[staticRSVP release];
//	staticRSVP = nil;
//	[dynamicRSVP release];
//	dynamicRSVP = nil;
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
	[eventDescriptionWhiteBack release];
	[eventDescription release];
	[eventMap release];
	[contact release];
	[checkIn release];
	[live release];
	[buttonWhiteBack release];
	[yourRSVPBack release];
	[staticRSVP release];
	[dynamicRSVP release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

@end
