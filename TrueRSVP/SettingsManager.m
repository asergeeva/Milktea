
//  SettingsManager.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "SettingsManager.h"
#import "SynthesizeSingleton.h"
#import "FlurryAnalytics.h"
@implementation SettingsManager
SYNTHESIZE_SINGLETON_FOR_CLASS(SettingsManager);
@synthesize settings;
@synthesize username;
- (id)init
{
	if((self = [super init]))
	{
		settings = [[NSMutableDictionary alloc] init];
		username = [[NSMutableString alloc] initWithString:@""];
		//[self load];
//		[self loadAddress];
		if(![[NSUserDefaults standardUserDefaults] objectForKey:@"rootAddress"])
		{
			[[NSUserDefaults standardUserDefaults] setValue:@"http://192.168.1.136/Eventfii/" forKey:@"rootAddress"];
		}
		if(![[NSUserDefaults standardUserDefaults] objectForKey:@"APILocation"])
		{
			[[NSUserDefaults standardUserDefaults] setValue:@"http://192.168.1.136/Eventfii/api/" forKey:@"APILocation"];
		}
		//[self save];
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
	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:username];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)load
{
	if([[NSUserDefaults standardUserDefaults] objectForKey:username])
	{
		[settings removeAllObjects];
		[settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:username]];
	}
}
- (NSNumber*)checkOfflineData
{
	NSNumber *isDataValid = [NSNumber numberWithBool:YES];
	NSDictionary *profileDictionary = [[SettingsManager sharedSettingsManager] loadDictionaryForKey:@"profile"];
	if([profileDictionary count] == 0)
	{
		isDataValid = [NSNumber numberWithBool:NO];
	}
	NSArray *attendingArray = [[SettingsManager sharedSettingsManager] loadArrayForKey:@"attendingList"];	
	NSArray *hostingArray = [[SettingsManager sharedSettingsManager] loadArrayForKey:@"hostingList"];	
	if([attendingArray count] == 0 && [hostingArray count] == 0)
	{
		isDataValid = [NSNumber numberWithBool:NO];
	}

	return isDataValid;
}
- (void)dealloc
{
	[settings release];
	[username release];
//	[rootAddress release];
//	[APILocation release];
//	[twitterCache release];
	[super dealloc];
}
@end
