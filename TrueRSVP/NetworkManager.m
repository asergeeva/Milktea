//
//  SharedNetwork.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "NetworkManager.h"
#import "SynthesizeSingleton.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "SettingsManager.h"
#import "Reachability.h"
#import "Attendee.h"
#import "Constants.h"
#import "QueuedActions.h"
#import <CoreLocation/CoreLocation.h>
#import "QueuedActions.h"
@implementation NetworkManager
SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkManager);
//@synthesize formReq;
//@synthesize httpReq;
@synthesize profile;
@synthesize attendingList;
@synthesize guestList;
//@synthesize attendingDetails;
@synthesize hostingList;
//@synthesize hostingDetails;
@synthesize delegate;
@synthesize connectionMonitor;
//NSString *APILocation;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		formReq = [[ASIFormDataRequest alloc] init];
		httpReq = [[ASIHTTPRequest alloc] init];
		profile = [[NSMutableDictionary alloc] init];
		attendingList = [[NSMutableArray alloc] init];
		guestList = [[NSMutableDictionary alloc] init];
//		attendingDetails = [[NSMutableDictionary alloc] init];
		hostingList = [[NSMutableArray alloc] init];
//		hostingDetails = [[NSMutableDictionary alloc] init];
		profileDone = NO;
		attendingDone = NO;
		hostingDone = NO;
		
		sm = [[SettingsManager sharedSettingsManager].settings retain];
		connectionMonitor = [Reachability reachabilityForInternetConnection];
		[connectionMonitor startNotifier];
		[[NSNotificationCenter defaultCenter]
		 addObserver: self
		 selector: @selector(connectivityChanged:)
		 name:  kReachabilityChangedNotification
		 object: connectionMonitor];
//		APILocation = [NSString stringWithFormat:@"%@", [sm objectForKey:@"APILocation"]];
    }
    return self;
}
- (void)connectivityChanged:(NSNotification*)notice
{
	//	Reachability *r = (Reachability*)[notice object];
	//	if([r currentReachabilityStatus] == NotReachable)
	//	{
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet" message:@"No internetion connection found. Going offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//	[alert show];
//	[alert release];
	//	}
}
- (BOOL)isOnline
{
	if([connectionMonitor currentReachabilityStatus] == NotReachable)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet" message:@"No internetion connection found. Going offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet" message:@"Internet Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	return ([connectionMonitor currentReachabilityStatus] != NotReachable);
}
- (void)didLoadProfile:(ASIFormDataRequest*)request
{
//	[delegate progressCheck];
	[profile removeAllObjects];
	[profile addEntriesFromDictionary:[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil]];
	[[SettingsManager sharedSettingsManager] saveDictionary:profile withKey:@"profile"];
	profileDone = YES;
	[[QueuedActions sharedQueuedActions] processQueue];
//	[self processQueue];
}
- (void)didLoadHostingList:(ASIFormDataRequest*)request
{
//	[delegate progressCheck];
//	[hostingList addObjectsFromArray:[[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil]];
	NSArray *hostingInfo = [NSDictionary dictionaryWithJSONString:[request responseString] error:nil];
	[hostingList removeAllObjects];
	[hostingList addObjectsFromArray:hostingInfo];
	[[SettingsManager sharedSettingsManager] saveArray:hostingList withKey:@"hostingList"];
	[guestList removeAllObjects];
	for(NSDictionary *dictionary in hostingList)
	{
		NSMutableArray *guestNameAttendance = [[NSMutableArray alloc] init];
		
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"], getGuestList]];
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
		[request addPostValue:[dictionary objectForKey:@"id"] forKey:@"eid"];
		[request startSynchronous];
		NSArray *guestNames = [[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil];
		for (NSDictionary *dictionary in guestNames)
		{
			Attendee *newAttendee = [[Attendee alloc] init];
			newAttendee.uid = [dictionary objectForKey:@"id"];
			//if(((NSString*)[dictionary objectForKey:@"fname"]) != [NSNull null])
			if((NSString*)[dictionary objectForKey:@"fname"])
				newAttendee.fname = [dictionary objectForKey:@"fname"];
			else
				newAttendee.fname = @" ";
			if([dictionary objectForKey:@"lname"] != [NSNull null])
				newAttendee.lname = [dictionary objectForKey:@"lname"];
			else
				newAttendee.lname = @" ";
			newAttendee.isAttending = [[dictionary objectForKey:@"is_attending"] boolValue];
			[guestNameAttendance addObject:newAttendee];
			[newAttendee release];
		}
		[guestList setObject:guestNameAttendance forKey:[dictionary objectForKey:@"id"]];
	}
	[[SettingsManager sharedSettingsManager] saveDictionary:guestList withKey:@"guestList"];
	hostingDone = YES;
}
- (void)didLoadAttendingList:(ASIFormDataRequest *)request
{
	[attendingList removeAllObjects];
	[attendingList addObjectsFromArray:[[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil]];
	[[SettingsManager sharedSettingsManager] saveArray:attendingList withKey:@"attendingList"];
	attendingDone = YES;
//	[delegate progressCheck];
}
- (void)refreshProfile
{

}
- (void)updateProfileWithEmail:(NSString*)email about:(NSString*)about cell:(NSString*)cell zip:(NSString*)zip twitter:(NSString*)twitter delegate:(UIViewController*)viewController
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], setUserInfo]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:email forKey:@"email"];
	[request addPostValue:about forKey:@"about"];
	[request addPostValue:cell forKey:@"cell"];
	[request addPostValue:zip forKey:@"zip"];
	[request addPostValue:twitter forKey:@"twitter"];
	request.delegate = viewController;
	[request startAsynchronous];
}
- (ASIHTTPRequest*)getOrganizerEmailForOrganizerID:(NSString*)oid
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], getOrganizerEmail]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:[NSString stringWithFormat:@"%@", oid] forKey:@"oid"];
	[request startSynchronous];
	return request;
}
- (void)getMapWithAddress:(NSString*)eventAddress delegate:(UIViewController*)viewController
{
	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventAddress];
	NSURL *mapURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	ASIHTTPRequest *requestMap = [ASIHTTPRequest requestWithURL:mapURL];
	[requestMap setDidFinishSelector:@selector(mapRequestFinished:)];
	requestMap.delegate = viewController;
	[requestMap startAsynchronous];
}
- (CLLocationCoordinate2D)getCoordsFromAddress:(NSString*)eventAddress
{
	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventAddress];
	NSURL *mapURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:mapURL];
	[request setDidFinishSelector:@selector(mapRequestFinished:)];
	[request startSynchronous];	
	NSDictionary *result = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSDictionary *location = [[[[result objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
	float lat = [[location objectForKey:@"lat"] floatValue];
	float lng = [[location objectForKey:@"lng"] floatValue];
	return CLLocationCoordinate2DMake(lat, lng);
}
- (void)getScoreWithEID:(NSString*)eid delegate:(UIViewController*)viewController
{
	NSURL *trueURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], computeTrueRSVP]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:trueURL];
	[request setPostValue:eid forKey:@"eid"];
	request.delegate = viewController;
	[request setDidFinishSelector:@selector(scoreLoadFinished:)];
	[request setDidFailSelector:@selector(scoreLoadFailed:)];
	[request startAsynchronous];
}
- (void)didFailedLoadingProfile:(ASIFormDataRequest*)request
{
	NSLog(@"Profile failed");
	[profile removeAllObjects];
	if([[SettingsManager sharedSettingsManager] loadDictionaryForKey:@"profile"])
		{
			[profile addEntriesFromDictionary:[[SettingsManager sharedSettingsManager] loadDictionaryForKey:@"profile"]];
		}
	profileDone = YES;
		[delegate offlineMode];

}
- (void)didFailedLoadingAttending:(ASIFormDataRequest*)request
{
	NSLog(@"Attending List failed");
	[attendingList removeAllObjects];
	if([[SettingsManager sharedSettingsManager] loadArrayForKey:@"attendingList"])
	{
		[attendingList addObjectsFromArray:[[SettingsManager sharedSettingsManager] loadArrayForKey:@"attendingList"]];
	}
	attendingDone = YES;
	[delegate offlineMode];
}
- (void)didFailedLoadingHosting:(ASIFormDataRequest*)request
{
	NSLog(@"Hosting List failed");
	[hostingList removeAllObjects];
	if ([[SettingsManager sharedSettingsManager] loadArrayForKey:@"hostingList"])
	{
		[hostingList addObjectsFromArray:[[SettingsManager sharedSettingsManager] loadArrayForKey:@"hostingList"]];
	}
	[guestList addEntriesFromDictionary:[[SettingsManager sharedSettingsManager] loadDictionaryForKey:@"guestList"]];
	hostingDone = YES;
	[delegate offlineMode];
}
- (void)refreshAll:(UIProgressView*)bar
{
	ASINetworkQueue *allQueue = [ASINetworkQueue queue];
	[allQueue setDownloadProgressDelegate:bar];
	NSURL *profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], getUserInfo]];
	ASIFormDataRequest *profileReq = [ASIFormDataRequest requestWithURL:profileURL];
	[profileReq setDelegate:self];
	[profileReq setDidFinishSelector:@selector(didLoadProfile:)];
	[profileReq setDidFailSelector:@selector(didFailedLoadingProfile:)];
	[allQueue addOperation:profileReq];
	
	NSURL *hostingListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], getHostingEvents]];
	ASIFormDataRequest *hostingListReq = [ASIFormDataRequest requestWithURL:hostingListURL];
	[hostingListReq setDelegate:self];
	[hostingListReq setDidFinishSelector:@selector(didLoadHostingList:)];
	[hostingListReq setDidFailSelector:@selector(didFailedLoadingHosting:)];
	[allQueue addOperation:hostingListReq];
	
	NSURL *attendingListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"], getAttendingEvents]];
	ASIFormDataRequest *attendingListReq = [ASIFormDataRequest requestWithURL:attendingListURL];
	[attendingListReq setDelegate:self];
	[attendingListReq setDidFinishSelector:@selector(didLoadAttendingList:)];
	[attendingListReq setDidFailSelector:@selector(didFailedLoadingAttending:)];
	[allQueue addOperation:attendingListReq];
	
	[allQueue go];
}
- (NSDate*)getDateForEID:(NSString*)eid uid:(NSString*)uid
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], getCheckInDate]]];
	[request setPostValue:eid forKey:@"eid"];
	[request setPostValue:uid forKey:@"uid"];
//	[request setValue:eid forKey:@"eid"];
//	[request setValue:uid forKey:@"uid"];
	[request startSynchronous];	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"YYYY-MM-dd HH:mm:ss";
	NSDate *date = [df dateFromString:[[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil] objectForKey:@"rsvp_time"]];
	[df release];
	return date;
}
- (void)checkInDateWithCheckIn:(CheckIn*)check
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], checkInWithDate]]];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
//	df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ";
	df.dateFormat = @"YYYY-MM-dd HH:mm:ss";
	[request setPostValue:[NSNumber numberWithBool:check.isAttending] forKey:@"checkIn"];
	[request setPostValue:check.eid forKey:@"eid"];
	[request setPostValue:check.uid forKey:@"uid"];
	[request setPostValue:[df stringFromDate:check.date] forKey:@"date"];
	[request startSynchronous];	
	[df release];
}
//- (void)checkInDistanceWithEID:(NSString*)eid delegate:(id)receiver
//{
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@checkInByDistance",[[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"]]];
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//	[request setPostValue:eid forKey:@"eid"];
//	request.delegate = receiver;
//	[request startAsynchronous];
//}
- (ASIHTTPRequest*)checkInWithEID:(NSString*)eid uid:(NSString*)uid checkInValue:(NSString*)checkInValue
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[sm objectForKey:@"APILocation"], checkIn]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:eid forKey:@"eid"];
	[request setPostValue:uid forKey:@"uid"];
	[request setPostValue:checkInValue forKey:@"checkIn"];
	[request startSynchronous];
	return request;
}
- (void)checkInWithEID:(NSString*)eid
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[sm objectForKey:@"APILocation"], @"checkInByDistance"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:eid forKey:@"eid"];
	[request startSynchronous];
	if([[request responseString] isEqualToString:@"status_checkInSuccess"])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
														message:@"You are now checked in!"
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
														message:@"Check-in unsuccessful. Try again later."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}
- (void)processQueue
{
	while([[QueuedActions sharedQueuedActions].queue count])
	{
		CheckIn *check = [[QueuedActions sharedQueuedActions].queue objectAtIndex:0];
		NSDate *date = [self getDateForEID:check.eid uid:check.uid];
		if([date timeIntervalSince1970] < [check.date timeIntervalSince1970])
		{
			[self checkInDateWithCheckIn:check];
		}
		[[QueuedActions sharedQueuedActions].queue removeObjectAtIndex:0];
	}
	[[QueuedActions sharedQueuedActions] save];
}
- (BOOL)checkFilled
{
	return (profileDone && attendingDone && hostingDone);
}
- (void)setAttendanceWithEID:(NSString*)eid confidence:(NSString*)confidence
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [sm objectForKey:@"APILocation"], setAttendanceForEvent]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:eid forKey:@"eid"];
	[request setPostValue:confidence forKey:@"confidence"];
	[request startAsynchronous];
}
- (void)dealloc
{
	[formReq release];
	[httpReq release];
	[profile release];
	[attendingList release];
	[guestList release];
//	[attendingDetails release];
	[hostingList release];
//	[hostingDetails release];
	[sm release];
	[super dealloc];
}
@end
