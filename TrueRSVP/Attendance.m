//
//  Attendance.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "Attendance.h"

@implementation Attendance
@synthesize eventsArray;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc
{
	[eventsArray release];
	[super dealloc];
}
@end