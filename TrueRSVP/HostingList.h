//
//  HostingList.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@interface HostingList : NSObject
{
	NSMutableArray *eventsArray;
}
+ (HostingList*)sharedHostingList;
- (void)updateEventsList:(NSArray*)eventsList;
@property (nonatomic, retain) NSMutableArray *eventsArray;
@end
