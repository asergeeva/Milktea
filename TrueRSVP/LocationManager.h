//
//  LocationManager.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/20/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
@class Event;
@interface LocationManager : NSObject <CLLocationManagerDelegate, ASIHTTPRequestDelegate>
{
	CLLocationManager *manager;
	NSMutableArray *eventArray;
}
+ (LocationManager*)sharedLocationManager;
- (Event*)getEvent:(NSString*)eid;
- (void)addEvent:(Event*)event;
- (void)removeAllEvents;
- (void)removeIrrelevantEvents;
- (void)removeEvent:(NSString*)eventID;
@property (nonatomic, retain) CLLocationManager *manager;
@property (nonatomic, retain) NSMutableArray *eventArray;
@end
