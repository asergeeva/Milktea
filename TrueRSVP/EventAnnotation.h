//
//  EventAnnotation.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface EventAnnotation : NSObject <MKAnnotation>
{
	NSString *name;
	CLLocationCoordinate2D coordinate;
}
- (id)initWithName:(NSString*)eventName coordinate:(CLLocationCoordinate2D)eventCoordinate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@end
