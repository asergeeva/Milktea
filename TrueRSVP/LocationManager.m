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
@synthesize _manager;
@synthesize eventArray;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		_manager = [[CLLocationManager alloc] init];
		_manager.delegate = self;
		_manager.desiredAccuracy = kCLLocationAccuracyBest;
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
	if(![self getEvent:event.eventID])
	{
		CLLocationCoordinate2D coords = [[NetworkManager sharedNetworkManager] getCoordsFromAddress:event.eventAddress];
		CLRegion *region = [[[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(coords.latitude, coords.longitude) radius:5000 identifier:event.eventID] autorelease];
		[_manager startMonitoringForRegion:region desiredAccuracy:1.0];
		[eventArray addObject:event];
		[_manager setPurpose:@"We need your permission to check you in automatically as soon as you are near the event."];
		[_manager startUpdatingLocation];
	}
	
}
- (void)removeEvent:(NSString*)eventID
{
	for(Event *event in eventArray)
	{
		if([event.eventID isEqual:eventID])
		{
			[eventArray removeObject:event];
		}
	}
	for(CLRegion *region in _manager.monitoredRegions)
	{
		if([region.identifier isEqual:eventID])
		{
			[_manager stopMonitoringForRegion:region];
		}
	}
}
- (void)removeAllEvents
{
	for(CLRegion *region in _manager.monitoredRegions)
	{
		[_manager stopMonitoringForRegion:region];
	}
	[eventArray removeAllObjects];
}
- (void)removeIrrelevantEvents
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd";
	for(Event *event in eventArray)
	{
		if(![[df stringFromDate:event.eventDate] isEqual:[df stringFromDate:[NSDate date]]])
		{
			[[LocationManager sharedLocationManager] removeEvent:event.eventID];
		}
	}
	[df release];
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
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSSet *locations = _manager.monitoredRegions;
	for(CLRegion *region in locations)
	{
		CLLocation *center = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
		if([newLocation distanceFromLocation:center]/1000 < 6)
		{
			[self locationManager:_manager didEnterRegion:region];
		}
		[center release];
			
	}
	
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
	[[NetworkManager sharedNetworkManager] checkInWithEID:[self getEvent:region.identifier].eventID showErrorNotification:NO];
	[eventArray removeObject:region];
	[_manager stopMonitoringForRegion:region];
	NSSet *regions = _manager.monitoredRegions;
	for(CLRegion *reg in regions)
	{
		NSLog(@"%@", reg.identifier);
	}
	
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
	NSLog(@"Exit");
//	UILocalNotification *notify =[[UILocalNotification alloc] init];
//	notify.alertAction = [[[NSString alloc] initWithString: @"Entered"] autorelease];
//	notify.fireDate = nil;
//	notify.alertBody = [NSString stringWithFormat:@"Entered"];
//	notify.soundName = UILocalNotificationDefaultSoundName;
//	[[UIApplication sharedApplication] presentLocalNotificationNow:notify];
//	[notify release];
}
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
	NSLog(@"fail monitoring");
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	
}
-(void)dealloc
{
	_manager.delegate = nil;
	[_manager release];
	[eventArray release];
	[super dealloc];
}
@end
