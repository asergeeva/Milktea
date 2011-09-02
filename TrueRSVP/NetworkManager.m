//
//  SharedNetwork.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Attendee.h"
#import "CJSONDeserializer.h"
#import "Constants.h"
#import "CheckIn.h"
#import "NetworkManager.h"
#import "NSDictionary_JSONExtensions.h"
#import "Reachability.h"
#import "SettingsManager.h"
#import "SynthesizeSingleton.h"
#import "OAuth.h"
#import "QueuedActions.h"
#import "LocationManager.h"
#import "Event.h"
@implementation NetworkManager
SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkManager);
@synthesize profile;
@synthesize attendingList;
@synthesize guestList;
@synthesize hostingList;
@synthesize delegate;
@synthesize profileDelegate;
@synthesize attendingDelegate;
@synthesize hostingDelegate;
@synthesize connectionMonitor;
//BOOL test = NO;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
//		formReq = [[ASIFomrDataRequest alloc] init];
//		httpReq = [[ASIHTTPRequest alloc] init];
		profile = [[NSMutableDictionary alloc] init];
		attendingList = [[NSMutableArray alloc] init];
		guestList = [[NSMutableDictionary alloc] init];
		hostingList = [[NSMutableArray alloc] init];
		profileDone = NO;
		attendingDone = NO;
		hostingDone = NO;
		sm = [SettingsManager sharedSettingsManager].settings;
		ud = [NSUserDefaults standardUserDefaults];
		connectionMonitor = [Reachability reachabilityForInternetConnection];
		[connectionMonitor startNotifier];
		[[NSNotificationCenter defaultCenter]
		 addObserver: self
		 selector: @selector(connectivityChanged:)
		 name:  kReachabilityChangedNotification
		 object: connectionMonitor];
    }
    return self;
}
- (void)connectivityChanged:(NSNotification*)notice
{
	//	Reachability *r = (Reachability*)[notice object];
	//	if([r currentReachabilityStatus] == NotReachable)
	//	{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet" message:@"No internetion connection found. Going offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	//	}
}
- (BOOL)isOnline
{
	connectionMonitor = [Reachability reachabilityForInternetConnection];
	[connectionMonitor startNotifier];
	if([connectionMonitor currentReachabilityStatus] == NotReachable)
	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet" message:@"No internetion connection found. Going offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//		[alert show];
//		[alert release];
	}
	else
	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet" message:@"Internet Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//		[alert show];
//		[alert release];
	}
	return ([connectionMonitor currentReachabilityStatus] != NotReachable);
}
- (NSString*)getUsernameWithUID:(NSString*)uid
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ud objectForKey:@"APILocation"], getUsername]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:uid forKey:@"uid"];
	[request startSynchronous];
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	return [NSString stringWithFormat:@"%@ %@", [dictionary objectForKey:@"fname"], [dictionary objectForKey:@"lname"]];
}
- (void)refreshAllWithDelegate:(UIViewController*)receiver completion:(SEL)finished
{
	ASINetworkQueue *allQueue = [ASINetworkQueue queue];
	[allQueue reset];
	
	NSURL *profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getUserInfo]];
	ASIFormDataRequest *profileReq = [ASIFormDataRequest requestWithURL:profileURL];
	profileReq.delegate = self;
	profileReq.didFinishSelector = @selector(didFinishLoadProfile:);
	profileReq.didFailSelector = @selector(didFailLoadProfile:);
	
	NSURL *hostingListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getHostingEvents]];
	ASIFormDataRequest *hostingListReq = [ASIFormDataRequest requestWithURL:hostingListURL];
	hostingListReq.delegate = self;
	hostingListReq.didFinishSelector = @selector(didFinishLoadHosting:);
	hostingListReq.didFailSelector = @selector(didFailLoadHosting:);
	
	NSURL *attendingListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getAttendingEvents]];
	ASIFormDataRequest *attendingListReq = [ASIFormDataRequest requestWithURL:attendingListURL];
	attendingListReq.delegate = self;
	attendingListReq.didFinishSelector = @selector(didFinishLoadAttending:);
	attendingListReq.didFailSelector = @selector(didFailLoadAttending:);
	[allQueue addOperation:profileReq];
	[allQueue addOperation:hostingListReq];
	[allQueue addOperation:attendingListReq];
	if(finished && receiver)
	{
		allQueue.delegate = receiver;
		allQueue.queueDidFinishSelector = finished;
	}
	[allQueue go];
}
- (void)didFinishLoadProfile:(ASIFormDataRequest*)request
{
	[profile removeAllObjects];
	[profile addEntriesFromDictionary:[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil]];
	[[SettingsManager sharedSettingsManager] saveDictionary:profile withKey:@"profile"];
	profileDone = YES;
	[[QueuedActions sharedQueuedActions] processQueue];
	[profileDelegate updateProfile];
	[self checkFilled];
//	[delegate progressCheck];
}
- (void)didFinishLoadHosting:(ASIFormDataRequest*)request
{
	NSArray *hostingInfo = [NSDictionary dictionaryWithJSONString:[request responseString] error:nil];
	[hostingList removeAllObjects];
	[hostingList addObjectsFromArray:hostingInfo];
	[[SettingsManager sharedSettingsManager] saveArray:hostingList withKey:@"hostingList"];
	[guestList removeAllObjects];
	for(NSDictionary *dictionary in hostingList)
	{
		NSMutableArray *guestNameAttendance = [[NSMutableArray alloc] init];
		
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getGuestList]];
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
			
			if([dictionary objectForKey:@"email"] != [NSNull null])
				newAttendee.email = [dictionary objectForKey:@"email"];
			else
				newAttendee.email = @" ";
			newAttendee.isAttending = [[dictionary objectForKey:@"is_attending"] boolValue];
			[guestNameAttendance addObject:newAttendee];
			[newAttendee release];
		}
		[guestList setObject:guestNameAttendance forKey:[dictionary objectForKey:@"id"]];
		[guestNameAttendance release]; ////????????????????
	}
	[[SettingsManager sharedSettingsManager] saveDictionary:guestList withKey:@"guestList"];
	hostingDone = YES;
	[hostingDelegate updateHosting];
	[self checkFilled];
//	[delegate progressCheck];
}
- (void)didFinishLoadAttending:(ASIFormDataRequest *)request
{
	[attendingList removeAllObjects];
	[attendingList addObjectsFromArray:[[CJSONDeserializer deserializer] deserializeAsArray:[request responseData] error:nil]];
	[[SettingsManager sharedSettingsManager] saveArray:attendingList withKey:@"attendingList"];
	attendingDone = YES;
	[attendingDelegate updateAttending];
	[self checkFilled];
//	[delegate progressCheck];
}
- (void)didFailLoadProfile:(ASIFormDataRequest*)request
{
	NSLog(@"Profile failed");
	[profile removeAllObjects];
	if([[SettingsManager sharedSettingsManager] loadDictionaryForKey:@"profile"])
	{
		[profile addEntriesFromDictionary:[[SettingsManager sharedSettingsManager] loadDictionaryForKey:@"profile"]];
	}
	profileDone = YES;
	[self checkFilled];
//	[delegate offlineMode];
	
}
- (void)didFailLoadAttending:(ASIFormDataRequest*)request
{
	NSLog(@"Attending List failed");
	[attendingList removeAllObjects];
	if([[SettingsManager sharedSettingsManager] loadArrayForKey:@"attendingList"])
	{
		[attendingList addObjectsFromArray:[[SettingsManager sharedSettingsManager] loadArrayForKey:@"attendingList"]];
	}
	attendingDone = YES;
	[self checkFilled];
//	[delegate offlineMode];
}
- (void)didFailLoadHosting:(ASIFormDataRequest*)request
{
	NSLog(@"Hosting List failed");
	[hostingList removeAllObjects];
	if ([[SettingsManager sharedSettingsManager] loadArrayForKey:@"hostingList"])
	{
		[hostingList addObjectsFromArray:[[SettingsManager sharedSettingsManager] loadArrayForKey:@"hostingList"]];
	}
	[guestList addEntriesFromDictionary:[[SettingsManager sharedSettingsManager] loadDictionaryForKey:@"guestList"]];
	hostingDone = YES;
	[self checkFilled];
//	[delegate offlineMode];
}
- (BOOL)isSessionAlive
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getUserInfo]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];	
	[request startSynchronous];
	if([[request responseString] isEqualToString:@"false"])
	{
		return NO;
	}
	return YES;
}
- (void)updateProfileWithEmail:(NSString*)email about:(NSString*)about cell:(NSString*)cell zip:(NSString*)zip twitter:(NSString*)twitter delegate:(UIViewController*)viewController
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], setUserInfo]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:email forKey:@"email"];
	[request addPostValue:about forKey:@"about"];
	[request addPostValue:cell forKey:@"cell"];
	[request addPostValue:zip forKey:@"zip"];
	if([twitter hasPrefix:@"@"])
	{
		[request addPostValue:[twitter substringFromIndex:1] forKey:@"twitter"];			
		[profile setObject:[twitter substringFromIndex:1] forKey:@"twitter"];
	}
	else
	{
		[request addPostValue:twitter forKey:@"twitter"];
		[profile setObject:twitter forKey:@"twitter"];
	}

	request.delegate = viewController;
	[profile setObject:email forKey:@"email"];
	[profile setObject:about forKey:@"about"];
	[profile setObject:cell forKey:@"cell"];
	[profile setObject:zip forKey:@"zip"];

	[request startAsynchronous];
}
- (int)getAttendanceForEvent:(NSString*)eid
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getAttendanceForEvent]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:eid forKey:@"eid"];
	[request startSynchronous];
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSLog(@"%@", [dictionary objectForKey:@"confidence"]);
	return [[dictionary objectForKey:@"confidence"] intValue];
}
- (ASIHTTPRequest*)getOrganizerEmailForOrganizerID:(NSString*)oid
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getOrganizerEmail]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:[NSString stringWithFormat:@"%@", oid] forKey:@"oid"];
	[request startSynchronous];
	return request;
}
- (void)getMapWithAddress:(NSString*)eventAddress delegate:(UIViewController*)viewController finishedSelector:(SEL)finished failedSelector:(SEL)failed
{
	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventAddress];
	NSURL *mapURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:mapURL];
	request.didFinishSelector = finished;
	request.didFailSelector = failed;
	request.delegate = viewController;
	[request startAsynchronous];
}

- (CLLocationCoordinate2D)getCoordsFromAddress:(NSString*)eventAddress //finishedSelector:(SEL)finished failedSelector:(SEL)failed
{
	NSString *urlAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", eventAddress];
	NSURL *mapURL = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:mapURL];
	[request startSynchronous];	
	NSDictionary *result = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	NSDictionary *location = [[[[result objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
	float lat = [[location objectForKey:@"lat"] floatValue];
	float lng = [[location objectForKey:@"lng"] floatValue];
	return CLLocationCoordinate2DMake(lat, lng);
}
- (void)getScoreWithEID:(NSString*)eid delegate:(UIViewController*)viewController finishedSelector:(SEL)finished failedSelector:(SEL)failed
{
	NSURL *trueURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], computeTrueRSVP]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:trueURL];
	[request setPostValue:eid forKey:@"eid"];
	request.delegate = viewController;
	request.didFinishSelector = finished;
	request.didFailSelector = failed;
	[request startAsynchronous];
}
- (NSDate*)getDateForEID:(NSString*)eid uid:(NSString*)uid
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], getCheckInDate]]];
	[request setPostValue:eid forKey:@"eid"];
	[request setPostValue:uid forKey:@"uid"];
	[request startSynchronous];	

	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"YYYY-MM-dd HH:mm:ss";
	NSDate *date = [df dateFromString:[[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil] objectForKey:@"rsvp_time"]];
	[df release];
	
	return date;
}
- (void)checkInDateWithCheckIn:(CheckIn*)check
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], checkInWithDate]]];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"YYYY-MM-dd HH:mm:ss";
	[request setPostValue:[NSNumber numberWithBool:check.isAttending] forKey:@"checkIn"];
	[request setPostValue:check.eid forKey:@"eid"];
	[request setPostValue:check.uid forKey:@"uid"];
	[request setPostValue:[df stringFromDate:check.date] forKey:@"date"];
	[request startSynchronous];	
	[df release];
}

- (ASIHTTPRequest*)checkInWithEID:(NSString*)eid uid:(NSString*)uid checkInValue:(NSString*)checkInValue
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ud objectForKey:@"APILocation"], checkIn]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:eid forKey:@"eid"];
	[request setPostValue:uid forKey:@"uid"];
	[request setPostValue:checkInValue forKey:@"checkIn"];
	[request startSynchronous];
	return request;
}
- (void)checkInWithEID:(NSString*)eid
{
	[self checkInWithEID:eid showErrorNotification:YES];
}
- (void)checkInWithEID:(NSString*)eid showErrorNotification:(BOOL)showNotification;
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ud objectForKey:@"APILocation"], @"checkInByDistance"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:eid forKey:@"eid"];
	[request startSynchronous];
	if([[request responseString] isEqualToString:@"status_checkInSuccess"])
	{
		Event *checkedInEvent = [[LocationManager sharedLocationManager] getEvent:eid];
		if(!showNotification)
		{
		[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_BACKGROUND_SUCCESS"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
														message:[NSString stringWithFormat:@"You are now checked into: %@", checkedInEvent.eventName]
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		}
		else
		{
			[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_BYLOCATION_SUCCESS"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In"
															message:@"You are now checked in."
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[[LocationManager sharedLocationManager] removeEvent:eid];
	}
	else
	{
		if(showNotification)
		{
			[FlurryAnalytics logEvent:@"ATTENDEE_CHECKIN_UNSUCCESSFUL_UNKNOWN"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" 
															message:@"Check-in unsuccessful. Try again later."
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}
- (void)uploadPhoto:(NSData*)imageData oauth:(OAuth*)oAuth delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed
{
	ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://api.twitpic.com/2/upload.json"]];
    [req addRequestHeader:@"X-Auth-Service-Provider" value:@"https://api.twitter.com/1/account/verify_credentials.json"];
    [req addRequestHeader:@"X-Verify-Credentials-Authorization"
                    value:[oAuth oAuthHeaderForMethod:@"GET"
                                               andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                            andParams:nil]];    
    
    [req setData:imageData forKey:@"media"];
    [req setPostValue:twitPicKey forKey:@"key"];
	req.delegate = receiver;
	[req setDidFinishSelector:finished];
	[req setDidFailSelector:failed];

    [req startAsynchronous];
}
- (void)updateStreamWithHashtag:(NSString*)hashtag delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%%23%@", hashtag]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	request.delegate = receiver;
	request.didFinishSelector = finished;
	request.didFailSelector = failed;
	[request startSynchronous];
}
- (void)uploadProfilePicWithImage:(UIImage*)image filename:(NSString*)filename delegate:(UIViewController*)receiver finishedSelector:(SEL)finish
{
	[FlurryAnalytics logEvent:@"PROFILE_UPDATE_PIC"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], @"uploadImage"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setData:UIImageJPEGRepresentation(image, 0.75) withFileName:@"8.jpg" andContentType:@"image/jpeg" forKey:@"qqfile"];
	request.delegate = receiver;
	request.didFinishSelector = finish;
	[request startAsynchronous];
}
- (void)sendMessageWithEventName:(NSString*)eventName eid:(NSString*)eid content:(NSString*)message selectionList:(NSArray*)selectedFromList messageType:(NSString*)type delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], sendMessage]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	for(int i = 0; i < selectedFromList.count; i++)
	{
		[request setPostValue:[selectedFromList objectAtIndex:i] forKey:[NSString stringWithFormat:@"uid[%i]", i]];
	}
	[request setPostValue:eid forKey:@"eventId"];
	[request setPostValue:[NSString stringWithFormat:@"Event: %@", eventName] forKey:@"reminderSubject"];
	[request setPostValue:message forKey:@"reminderContent"];
	[request setPostValue:type forKey:@"form"];
	request.delegate = receiver;
	request.didFinishSelector = finished;
	request.didFailSelector = failed;
	[request startAsynchronous];
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
	if(profileDone && attendingDone && hostingDone)
	{
		profileDone = NO;
		attendingDone = NO;
		hostingDone = NO;
		[delegate progressFinished];
		return YES;
	}
	return NO;
}
- (void)setAttendanceWithEID:(NSString*)eid confidence:(NSString*)confidence
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], setAttendanceForEvent]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:eid forKey:@"eid"];
	[request setPostValue:confidence forKey:@"confidence"];
	[request startAsynchronous];
}
- (void)isCheckedInWithEID:(NSString*)eid didFinish:(SEL)finished delegate:(id)receiver
{		
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], isAttending]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	request.delegate = receiver;
	[request addPostValue:eid forKey:@"eid"];
	[request startAsynchronous];
	request.didFinishSelector = finished;
}
- (void)logout
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [ud objectForKey:@"APILocation"], logout]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startAsynchronous];
}
- (void)dealloc
{
//	[formReq release];
//	[httpReq release];
	[profile release];
	[attendingList release];
	[guestList release];
//	[attendingDetails release];
	[hostingList release];
//	[hostingDetails release];
//	[sm release];
	[super dealloc];
}
@end
