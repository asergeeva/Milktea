//
//  SettingsManager.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "SettingsManager.h"
#import "SynthesizeSingleton.h"

@implementation SettingsManager
SYNTHESIZE_SINGLETON_FOR_CLASS(SettingsManager);
@synthesize welcomeDismissed;
@synthesize rootAddress;
@synthesize APILocation;
- (id)init
{
	if((self = [super init]))
	{
		welcomeDismissed = NO;
//		NSString *const rootAddress = @"http://192.168.1.135/Eventfii/";
//		NSString *const APILocation = @"http://192.168.1.135/Eventfii/api/";
		rootAddress = [[NSMutableString alloc] initWithString:@"http://192.168.1.135/Eventfii/"];
		APILocation = [[NSMutableString alloc] initWithString:@"http://192.168.1.135/Eventfii/api/"];
		[self load];
	}
	return self;
}
- (void)save
{
	[[NSUserDefaults standardUserDefaults] setObject:rootAddress forKey:@"rootAddress"];
	[[NSUserDefaults standardUserDefaults] setObject:APILocation forKey:@"APILocation"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)load
{
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"rootAddress"])
	{
		[rootAddress setString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootAddress"]];
	}
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"APILocation"])
	{
		[APILocation setString:[[NSUserDefaults standardUserDefaults] objectForKey:@"APILocation"]];
	}
}
- (void)dealloc
{
	[rootAddress release];
	[APILocation release];
	[super dealloc];
}
@end
