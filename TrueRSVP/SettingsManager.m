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
		settings = [[NSMutableDictionary alloc] init];
		[self load];
		if(![settings objectForKey:@"rootAddress"])
		{
			[settings setValue:@"http://192.168.1.136/Eventfii/" forKey:@"rootAddress"];
		}
		if(![settings objectForKey:@"APILocation"])
		{
			[settings setValue:@"http://192.168.1.136/Eventfii/api/" forKey:@"APILocation"];
		}
		[self save];
	}
	return self;
}
- (void)saveDictionary:(NSMutableDictionary*)dictionary withKey:(NSString*)key
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:key];	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)saveArray:(NSMutableArray*)array withKey:(NSString*)key
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:key];	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSMutableDictionary*)loadDictionaryForKey:(NSString*)key
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}
- (NSMutableArray*)loadArrayForKey:(NSString*)key
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
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
