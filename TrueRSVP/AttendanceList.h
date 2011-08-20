//
//  Attendance.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@interface AttendanceList : NSObject <NSCoding>
{
	NSMutableArray *eventsArray;
}
+ (AttendanceList*)sharedAttendanceList;
- (void)updateEventsList:(NSArray*)eventsList;
@property (nonatomic, retain) NSMutableArray *eventsArray;
@end
