//
//  HostingController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "HostingController.h"
#import "HostingList.h"
#import "NSDictionary_JSONExtensions.h"
@implementation HostingController
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
		[NetworkManager sharedNetworkManager].hostingDelegate = self;
		[self refresh];
    }
    
    return self;
}
#pragma mark - Unload
- (void)dealloc
{
	[NetworkManager sharedNetworkManager].hostingDelegate = nil;
	[super dealloc];
}
#pragma mark - Other
- (void)updateHosting
{
	[self refresh];
}
- (void)refresh
{
	[[HostingList sharedHostingList] updateEventsList:[NetworkManager sharedNetworkManager].hostingList];
	eventArray = [HostingList sharedHostingList].eventsArray;
}
@end

