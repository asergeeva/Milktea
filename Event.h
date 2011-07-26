//
//  EventAttending.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
{
	NSMutableString *eventID;
	NSMutableString *eventOrganizer;
	NSMutableString *eventName;
	NSMutableString *eventDescription;
	NSMutableString *eventAddress;
	NSDate *eventDate;
}
@property (nonatomic, retain) NSMutableString *eventID;
@property (nonatomic, retain) NSMutableString *eventOrganizer;
@property (nonatomic, retain) NSMutableString *eventName;
@property (nonatomic, retain) NSMutableString *eventDescription;
@property (nonatomic, retain) NSMutableString *eventAddress;
@property (nonatomic, retain) NSDate *eventDate;
@end
