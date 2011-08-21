//
//  LocationManager.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/20/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Event.h"
#import "NetworkManager.h"
@interface LocationManager : NSObject <CLLocationManagerDelegate, ASIHTTPRequestDelegate>
{
	CLLocationManager *manager;
	NSMutableArray *eventArray;
}
+ (LocationManager*)sharedLocationManager;
- (void)addEvent:(Event*)event;
@property (nonatomic, retain) CLLocationManager *manager;
@property (nonatomic, retain) NSMutableArray *eventArray;
@end
