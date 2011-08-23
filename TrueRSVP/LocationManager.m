//
//  LocationManager.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/20/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "LocationManager.h"
#import "SynthesizeSingleton.h"
#import "MiscHelper.h"
#import "NetworkManager.h"
#import "Event.h"
@implementation LocationManager
SYNTHESIZE_SINGLETON_FOR_CLASS(LocationManager);
@synthesize manager;
@synthesize eventArray;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		manager = [[CLLocationManager alloc] init];
		manager.delegate = self;
		eventArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}
//- (void)test
//{
//	CLRegion *region = [[[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(34.098006, -118.332767) radius:500 identifier:@"work"] autorelease];
//	[manager startMonitoringForRegion:region desiredAccuracy:1.0];
//}
- (void)addEvent:(Event*)event
{
	CLLocationCoordinate2D coords = [[NetworkManager sharedNetworkManager] getCoordsFromAddress:event.eventAddress];
	CLRegion *region = [[[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(coords.latitude, coords.longitude) radius:500 identifier:event.eventID] autorelease];
	[manager startMonitoringForRegion:region desiredAccuracy:1.0];
	[manager startUpdatingLocation];
}
- (Event*)getEvent:(NSString*)eid
{
	for(Event *event in eventArray)
	{
		if([event.eventID isEqual:eid])
		{
			return event;
		}
	}
	return nil;
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
	UILocalNotification *notify =[[UILocalNotification alloc] init];
	notify.alertAction = [[[NSString alloc] initWithString: @"Entered"] autorelease];
	notify.fireDate = nil;
	notify.alertBody = [NSString stringWithFormat:@"Entered"];
	notify.soundName = UILocalNotificationDefaultSoundName;
	[[UIApplication sharedApplication] presentLocalNotificationNow:notify];
	[notify release];
//	[[NetworkManager sharedNetworkManager] checkInDistanceWithEID:[self getEvent:region.identifier].eventID delegate:self];
	[[NetworkManager sharedNetworkManager] checkInWithEID:[self getEvent:region.identifier].eventID];
	[self.manager stopMonitoringForRegion:region];
	
}
//- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
//{
//	UILocalNotification *notify =[[UILocalNotification alloc] init];
//	notify.alertAction = [[[NSString alloc] initWithString: @"Entered"] autorelease];
//	notify.fireDate = nil;
//	notify.alertBody = [NSString stringWithFormat:@"Entered"];
//	notify.soundName = UILocalNotificationDefaultSoundName;
//	[[UIApplication sharedApplication] presentLocalNotificationNow:notify];
//	[notify release];
//}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	
}
-(void)dealloc
{
	manager.delegate = nil;
	[manager release];
	[eventArray release];
	[super dealloc];
}
@end
