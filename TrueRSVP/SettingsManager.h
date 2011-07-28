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
	BOOL welcomeDismissed;
	NSMutableString *rootAddress;
	NSMutableString *APILocation;
	
}
- (void)save;
- (void)load;
+ (SettingsManager*)sharedSettingsManager;
@property (nonatomic) BOOL welcomeDismissed;
@property (nonatomic, retain) NSMutableString *rootAddress;
@property (nonatomic, retain) NSMutableString *APILocation;
@end
