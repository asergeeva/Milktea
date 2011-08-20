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
NSString *APILocation;
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
		APILocation = [NSString stringWithFormat:@"%@", [sm objectForKey:@"APILocation"]];
    }
    return self;
}
- (void)didLoadProfile:(ASIFormDataRequest*)request
{
//	[delegate progressCheck];
	[profile removeAllObjects];
	[profile addEntriesFromDictionary:[[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil]];
	[[SettingsManager sharedSettingsManager] saveDictionary:profile withKey:@"profile"];
	profileDone = YES;
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
	[[SettingsManager sharedSettingsManager] saveArray:hostingList withKey:@"attendingList"];
	attendingDone = YES;
//	[delegate progressCheck];
}
- (void)refreshProfile
{

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
	NSURL *profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APILocation, getUserInfo]];
	ASIFormDataRequest *profileReq = [ASIFormDataRequest requestWithURL:profileURL];
	[profileReq setDelegate:self];
	[profileReq setDidFinishSelector:@selector(didLoadProfile:)];
	[profileReq setDidFailSelector:@selector(didFailedLoadingProfile:)];
	[allQueue addOperation:profileReq];
	
	NSURL *hostingListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APILocation, getHostingEvents]];
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
- (BOOL)checkFilled
{
	return (profileDone && attendingDone && hostingDone);
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
