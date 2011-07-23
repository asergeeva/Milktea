//
//  EventAttending.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventAttending : NSObject
{
	NSString *eventName;
	NSString *eventDescription;
}
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventDescription;
@end
