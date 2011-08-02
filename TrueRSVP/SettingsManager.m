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
@synthesize settings;
- (id)init
{
	if((self = [super init]))
	{
		[self load];
		settings = [[NSMutableDictionary alloc] init];
		if(![settings objectForKey:@"rootAddress"])
		{
			[settings setValue:@"http://192.168.1.135/Eventfii/" forKey:@"rootAddress"];
		}
		if(![settings objectForKey:@"APILocation"])
		{
			[settings setValue:@"http://192.168.1.135/Eventfii/api/" forKey:@"APILocation"];
		}
		[self save];

	}
	return self;
}
- (void)save
{
	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"settings"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)load
{
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"settings"])
	{
		settings = [[[NSUserDefaults standardUserDefaults] objectForKey:@"settings"] mutableCopy];
	}
}
- (void)dealloc
{
	[settings release];
//	[rootAddress release];
//	[APILocation release];
//	[twitterCache release];
	[super dealloc];
}
@end
