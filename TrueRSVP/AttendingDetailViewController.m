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
#import "QueuedActions.h"
#import "User.h"
#import "FlurryAnalytics.h"
#import "RSVPViewController.h"
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
@synthesize reader;
//@synthesize address;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) 
//	{
//        // Custom initialization
//		eventAttending = event;
//		//[eventAttending retain];
//		reader = [ZBarReaderViewController new];
//		reader.readerDelegate = self;
//		reader.showsZBarControls = NO;
//		[reader.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
//		[reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
////		address = [[NSMutableString alloc] init];
//		choices = [[NSArray alloc] initWithObjects:@"Absolutely", @"Pretty Sure", "50/50", "Most Likely Not", @"Raincheck", nil];
////				   NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:6];
////				   [array addObject:@"Absolutly"];
////				   [array addObject:@"Pretty Sure"];
////				   [array addObject:@"50/50"];
////				   [array addObject:@"Most Likely Not"];
////				   [array addObject:@"Raincheck"];
//    }
//    return self;
//}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		reader = [ZBarReaderViewController new];
		reader.readerDelegate = self;
		reader.showsZBarControls = NO;
		[reader.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
		[reader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
		choices = [[NSArray alloc] initWithObjects:@"Absolutely", @"Pretty Sure", @"50/50", @"Most Likely Not", @"Raincheck", nil];
//		picker = [[UIPickerView alloc] init];
//		isPickerResigned = YES;
    }
    return self;
}
- (IBAction)showLive:(UIButton*)sender
{
	[FlurryAnalytics logEvent:@"ATTENDEE_CHECK_LIVE_FEED"];
	LiveViewController *liveVC = [[[LiveViewController alloc] initWithNibName:@"LiveViewController" bundle:[NSBundle mainBundle] event:eventAttending] autorelease];
	[self.navigationController pushViewController:liveVC animated:YES];
	
}
- (IBAction)showMail:(UIButton*)sender
{
	[FlurryAnalytics logEvent:@"ATTENDEE_EMAIL_ORGANIZER"];
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
	[FlurryAnalytics logEvent:@"ATTENDEE_LAUNCHED_GOOGLEMAPS"];
	NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", eventAttending.eventAddress] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	[[UIApplication sharedApplication] openURL:url];
}
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//	return 1;
//}
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//	return 5;
//}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//	return [UIScreen mainScreen].applicationFrame.size.width-20;
//}
//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//	return [choices objectAtIndex:row];
//}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//	[pickerView selectRow:row inComponent:component animated:YES];
//}
//- (void)dismissPicker
//{
//	[UIView animateWithDuration:0.3 animations:^(void) {
//		CGRect frame = picker.frame;
//		frame.origin.y += picker.frame.size.height;
//		picker.frame = frame;
//	}];
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
////	for(UIView *view in self.view.subviews)
////	{
//		for (UITouch *touch in touches)
//		{
//			if(CGRectContainsPoint(picker.frame, [touch locationInView:picker]))
//			{
//			
//					return;
//			}
//		}
////	}
//	if(!isPickerResigned)
//	{
//		[self dismissPicker];
//		isPickerResigned = YES;
//	}
//	[super touchesBegan:touches withEvent:event];
//}
- (IBAction)showRSVP:(UIButton*)sender
{
//	isPickerResigned = NO;
	RSVPViewController *rsvpVC = [[RSVPViewController alloc] initWithNibName:@"RSVPViewController" bundle:[NSBundle mainBundle] event:eventAttending];
	[self.navigationController pushViewController:rsvpVC animated:YES];
	[rsvpVC release];
//	NSString *absolutely = @"Absolutely";
//	NSString *prettySure = @"Pretty Sure";
//	NSString *fifty = @"50/50";
//	NSString *likelyNot = @"Most Likely Not";
//	NSString *rainCheck = @"Raincheck";
//	if([[NetworkManager sharedNetworkManager] isOnline])
//	{
//		switch([[NetworkManager sharedNetworkManager] getAttendanceForEvent:eventAttending.eventID])
//		{
//			case 90:
//				absolutely = [NSString stringWithFormat:@"*%@",absolutely];
//				break;
//			case 65:
//				prettySure = [NSString stringWithFormat:@"*%@", prettySure];
//				break;
//			case 35:
//				fifty = [NSString stringWithFormat:@"*%@", fifty];
//				break;
//			case 15:
//				likelyNot = [NSString stringWithFormat:@"*%@", likelyNot];
//				break;
//			case 4:
//				rainCheck = [NSString stringWithFormat:@"*%@", rainCheck];
//				break;
//			default:
//				break;
//		}
//	}
//	[UIView animateWithDuration:0.3 animations:^(void) {
//		CGRect frameAnimate = picker.frame;
//		frameAnimate.origin.y -= picker.frame.size.height + 44;
//		picker.frame = frameAnimate;
//	}];
//	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Update RSVP" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:absolutely, prettySure, fifty, likelyNot, rainCheck, nil];
//	[sheet showInView:self.view];
//	[sheet release];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		[self presentModalViewController:reader animated:YES];
	}
}
- (IBAction)checkIn:(UIButton*)sender
{
	CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
	CLLocationDistance distance = [destinationLocation distanceFromLocation:eventMap.userLocation.location];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd";
	if(![[df stringFromDate:eventAttending.eventDate] isEqualToString:[df stringFromDate:[NSDate date]]])
	{
		[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_ATTEMPT_WRONGDATE"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
														message:@"You must only check-in on the event date."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
	else if(distance > 3218 || distance < 0)
	{
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{ 
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In"
															message:@"Cannot check-in by distance. You may check-in through scanning a QR code if the host has provided one."
														   delegate:self
												  cancelButtonTitle:@"Cancel" 
												  otherButtonTitles:@"OK", nil];
			[alert show];
			[alert release];
		}
		else if(distance < 0)
		{
			[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_ATTEMPT_UNLOCATABLE"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
															message:@"Unable to locate your position. Please enable location services for this app."
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];	
		}
		else
		{
			[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_ATTEMPT_TOOFAR"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
															message:@"You are either too far or GPS is currently inaccurate. Try again when you are closer to the event."
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
	else
	{
		[[NetworkManager sharedNetworkManager] checkInWithEID:eventAttending.eventID];
	}
	[destinationLocation release];
	[df release];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
	for(ZBarSymbol *symbol in results)
	{
		NSString *QRData = symbol.data;
//		QRData.text = symbol.data;
		NSArray *splitString = [QRData componentsSeparatedByString:@"-"];
		if(splitString.count != 3)
		{
			[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_QR_INVALID_CODE_UNKNOWN"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid QR Code" message:@"This QR code is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else if(![[splitString objectAtIndex:1] isEqualToString:eventAttending.eventID])
		{
			[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_QR_INVALID_CODE_ANOTHER_EVENT"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid QR Code" message:@"This QR code is for another event!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			if(![[NetworkManager sharedNetworkManager] isOnline])
			{
				[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_QR_OFFLINE"];
				[[QueuedActions sharedQueuedActions] addActionWithEID:[splitString objectAtIndex:1] userID:[User sharedUser].uid attendance:YES date:[NSDate date]];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline" message:@"You'll be checked-in the next time you connect to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			else
			{
				[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_QR_SUCCESS"];
				[[NetworkManager sharedNetworkManager] checkInWithEID:[splitString objectAtIndex:1] uid:[User sharedUser].uid checkInValue:@"1"];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Checked In!" message:@"You have been checked-in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
	}
	[reader dismissModalViewControllerAnimated:YES];
//	[self presentModalViewController:reader animated:NO];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	int confidence = 0;
	switch (buttonIndex)
	{
		case 0:
			[FlurryAnalytics logEvent:@"ATTENDEE_UPDATED_RSVP_CONF90"];
			confidence = 90;
			break;
		case 1:
			[FlurryAnalytics logEvent:@"ATTENDEE_UPDATED_RSVP_CONF65"];
			confidence = 65;
			break;
		case 2:
			[FlurryAnalytics logEvent:@"ATTENDEE_UPDATED_RSVP_CONF35"];
			confidence = 35;
			break;
		case 3:
			[FlurryAnalytics logEvent:@"ATTENDEE_UPDATED_RSVP_CONF15"];
			confidence = 15;
			break;
		case 4:
			[FlurryAnalytics logEvent:@"ATTENDEE_UPDATED_RSVP_CONF4"];
			confidence = 4;
			break;
//		case 5:
//			confidence = 1;
//			break;
		default:
			confidence = 5;
			break;
	}

	[[NetworkManager sharedNetworkManager] setAttendanceWithEID:eventAttending.eventID confidence:[NSString stringWithFormat:@"%d", confidence]];
}
- (void)viewWillDisappear:(BOOL)animated
{
//	[self dismissPicker];
	[super viewWillDisappear:animated];
}
- (void)checkAttending:(ASIHTTPRequest*)request
{
//	NSLog(@"%@", [request responseString]);
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	if([[dictionary objectForKey:@"is_attending"] isEqual:@"1"])
	{
		[checkIn setTitle:@"Already checked in!" forState:UIControlStateNormal];
		checkIn.enabled = NO;
	}
}
- (void)viewDidAppear:(BOOL)animated
{
	[[NetworkManager sharedNetworkManager] getMapWithAddress:eventAttending.eventAddress delegate:self finishedSelector:@selector(mapRequestFinished:) failedSelector:@selector(mapRequestFailed:)];
	[[NetworkManager sharedNetworkManager] isCheckedInWithEID:eventAttending.eventID didFinish:@selector(checkAttending:) delegate:self];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
	eventMap.alpha = 0;
	eventMap.hidden = YES;
	eventAddress.alpha = 0;
	eventAddress.hidden = NO;
	[super viewDidDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
	[checkIn setTitle:@"Check in to event" forState:UIControlStateNormal];
	checkIn.enabled = YES;
	eventName.text = eventAttending.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:eventAttending.eventDate];
	eventDescription.text = eventAttending.eventDescription;
	[df release];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[super viewWillAppear:animated];
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
- (void)dismissCamera
{
	[self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	eventMap.alpha = 0;
	eventMap.hidden = YES;
	eventAddress.alpha = 0;
	eventAddress.hidden = YES;
//	picker.delegate = self;
//	picker.dataSource = self;
//	[self.view addSubview:picker];
//	picker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//	CGRect frame = picker.frame;
//	frame.origin.y = 44 + [UIScreen mainScreen].applicationFrame.size.height;
//	picker.frame = frame;
//	picker.contentMode = UIViewContentModeBottom;
//	picker.showsSelectionIndicator = YES;
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
	
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 450, 320, 30)] autorelease];
	view.backgroundColor = [UIColor whiteColor];
	UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 70, 30)];
	[doneButton setImage:[UIImage imageNamed:@"doneButton.png"] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(dismissCamera) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:doneButton];
	[doneButton release];
	reader.cameraOverlayView = view;
}

- (void)viewDidUnload
{
	[eventAddress release];
	eventAddress = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
//	[eventAttending release];
	[eventDescriptionWhiteBack release];
	[eventName release];
	[eventDate release];
	[eventDescription release];
	[eventMap release];
	[contact release];
	[directions release];
	[update release];
	[checkIn release];
	[live release];
	[buttonWhiteBack release];
	[organizerEmail release];
	[reader release];
//	[picker release];
//	[QRData release];
	
//	[someURL release];
//	[address release];
	[eventAddress release];
	[choices release];
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
	eventMap.hidden = NO;
	[UIView animateWithDuration:0.3 animations:^(void) {
		eventMap.alpha = 1.0;
	}];
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
- (void)mapRequestFailed:(ASIHTTPRequest *)request
{
	eventAddress.text = eventAttending.eventAddress;
	eventAddress.hidden = NO;
	[UIView animateWithDuration:0.3 animations:^(void) {
		eventAddress.alpha = 1.0;
	}];
	NSLog(@"Loading Map failed");	
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
		eventAddress.frame = eventMap.frame;
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
		eventAddress.frame = eventMap.frame;
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
