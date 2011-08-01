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
@synthesize twitterCache;
- (id)init
{
	if((self = [super init]))
	{
		welcomeDismissed = NO;
//		NSString *const rootAddress = @"http://192.168.1.135/Eventfii/";
//		NSString *const APILocation = @"http://192.168.1.135/Eventfii/api/";
		rootAddress = [[NSMutableString alloc] initWithString:@"http://207.151.245.214/Eventfii/"];
		APILocation = [[NSMutableString alloc] initWithString:@"http://207.151.245.214/Eventfii/api/"];
		twitterCache = [[NSMutableString alloc] init];
		[self load];
	}
	return self;
}
- (void)save
{
	[[NSUserDefaults standardUserDefaults] setObject:rootAddress forKey:@"rootAddress"];
	[[NSUserDefaults standardUserDefaults] setObject:APILocation forKey:@"APILocation"];
	[[NSUserDefaults standardUserDefaults] setObject:twitterCache forKey:@"twitterCache"];
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
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"twitterCache"])
	{
		[twitterCache setString:[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterCache"]];
	}	
}
- (void)dealloc
{
	[rootAddress release];
	[APILocation release];
	[twitterCache release];
	[super dealloc];
}
@end
