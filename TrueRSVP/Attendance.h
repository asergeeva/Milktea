//
//  Attendance.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAttending.h"
@interface Attendance : NSObject
{
	NSMutableArray *eventsArray;
}
+ (Attendance*)sharedAttendance;
- (void)updateAttendance:(NSArray*)attendance;
@property (nonatomic, retain) NSMutableArray *eventsArray;
@end
