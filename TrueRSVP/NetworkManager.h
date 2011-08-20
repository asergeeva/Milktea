//
//  SharedNetwork.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "SettingsManager.h"
@protocol NetworkManagerDelegate
@optional
- (void)progressCheck;
- (void)offlineMode;
@end
@interface NetworkManager : NSObject
{
	ASIFormDataRequest *formReq;
	ASIHTTPRequest *httpReq;
	NSMutableDictionary *profile;
	NSMutableArray *attendingList;
//	NSMutableDictionary *attendingDetails;
	NSMutableArray *hostingList;
//	NSMutableDictionary *hostingDetails;
	NSMutableDictionary *sm;
	NSMutableDictionary *guestList;
	BOOL profileDone;
	BOOL attendingDone;
	BOOL hostingDone;
	id<NetworkManagerDelegate> delegate;
	
}
+ (NetworkManager*)sharedNetworkManager;
- (void)didLoadProfile:(ASIFormDataRequest*)request;
- (void)didLoadHostingList:(ASIFormDataRequest*)request;
- (void)didLoadAttendingList:(ASIFormDataRequest*)request;
- (void)refreshAll:(UIProgressView*)bar;
- (BOOL)checkFilled;
//@property (nonatomic, retain) ASIFormDataRequest *formReq;
//@property (nonatomic, retain) ASIHTTPRequest *httpReq;
@property (nonatomic, retain) NSMutableDictionary *profile;
@property (nonatomic, retain) NSMutableArray *attendingList;
//@property (nonatomic, retain) NSMutableDictionary *attendingDetails;
@property (nonatomic, retain) NSMutableArray *hostingList;
@property (nonatomic, retain) NSMutableDictionary *guestList;
//@property (nonatomic, retain) NSMutableDictionary *hostingDetails;
@property (nonatomic, assign) id<NetworkManagerDelegate> delegate;
@end
