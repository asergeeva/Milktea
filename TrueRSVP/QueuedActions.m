//
//  QueuedActions.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "QueuedActions.h"
#import "SettingsManager.h"
#import "SynthesizeSingleton.h"
#import "NetworkManager.h"
@implementation QueuedActions
SYNTHESIZE_SINGLETON_FOR_CLASS(QueuedActions)
@synthesize queue;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		queue = [[NSMutableArray alloc] init];
		if ([[SettingsManager sharedSettingsManager] loadArrayForKey:@"queue"])
		{
			[queue addObjectsFromArray:[[SettingsManager sharedSettingsManager] loadArrayForKey:@"queue"]];
		}
    }
    
    return self;
}
- (void)addActionWithEID:(NSString*)eid userID:(NSString*)uid attendance:(BOOL)isAttending date:(NSDate*)date
{
	CheckIn *check = [[CheckIn alloc] init];
	check.eid = eid;
	check.uid = uid;
	check.isAttending = isAttending;
	check.date = date;
	[queue addObject: check];
	[check release];
	[self save];
}
- (void)save
{
	[[SettingsManager sharedSettingsManager] saveArray:queue withKey:@"queue"];
}
- (void)load
{
	if ([[SettingsManager sharedSettingsManager] loadArrayForKey:@"queue"])
	{
		[queue removeAllObjects];
		[queue addObjectsFromArray:[[SettingsManager sharedSettingsManager] loadArrayForKey:@"queue"]];
	}
}
- (void)processQueue
{
	while([queue count])
	{
		CheckIn *check = [[QueuedActions sharedQueuedActions].queue objectAtIndex:0];
		NSDate *date = [[NetworkManager sharedNetworkManager] getDateForEID:check.eid uid:check.uid];
		if([date timeIntervalSince1970] < [check.date timeIntervalSince1970])
		{
			[[NetworkManager sharedNetworkManager] checkInDateWithCheckIn:check];
		}
		[[QueuedActions sharedQueuedActions].queue removeObjectAtIndex:0];
	}
	[[QueuedActions sharedQueuedActions] save];
}
- (void)dealloc
{
	[queue release];
	[super dealloc];
}
@end
