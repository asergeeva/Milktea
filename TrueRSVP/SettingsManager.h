//
//  SettingsManager.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject
{
	NSMutableDictionary *settings;
	NSMutableString *username;
}
- (void)save;
- (void)load;
+ (SettingsManager*)sharedSettingsManager;
- (void)saveDictionary:(NSMutableDictionary*)dictionary withKey:(NSString*)key;
- (void)saveArray:(NSMutableArray*)array withKey:(NSString*)key;
- (NSMutableDictionary*)loadDictionaryForKey:(NSString*)key;
- (NSMutableArray*)loadArrayForKey:(NSString*)key;
- (NSNumber*)checkOfflineData;
@property (nonatomic, retain) NSMutableDictionary *settings;
@property (nonatomic, retain) NSMutableString *username;
@end