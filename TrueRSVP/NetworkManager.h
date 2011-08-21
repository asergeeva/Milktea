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
#import <CoreLocation/CoreLocation.h>
#import "Event.h"
#import "Reachability.h"
#import "CheckIn.h"
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
	Reachability *r;
	id<NetworkManagerDelegate> delegate;
	Reachability *connectionMonitor;
}
+ (NetworkManager*)sharedNetworkManager;
- (void)didLoadProfile:(ASIFormDataRequest*)request;
- (void)didLoadHostingList:(ASIFormDataRequest*)request;
- (void)didLoadAttendingList:(ASIFormDataRequest*)request;
- (void)getScoreWithEID:(NSString*)eid delegate:(UIViewController*)viewController;
- (void)refreshAll:(UIProgressView*)bar;
- (BOOL)checkFilled;
- (void)processQueue;
- (void)getMapWithAddress:(NSString*)eventAddress delegate:(UIViewController*)viewController;
- (ASIHTTPRequest*)getOrganizerEmailForOrganizerID:(NSString*)oid;
- (void)updateProfileWithEmail:(NSString*)email about:(NSString*)about cell:(NSString*)cell zip:(NSString*)zip twitter:(NSString*)twitter delegate:(UIViewController*)viewController;
- (CLLocationCoordinate2D)getCoordsFromAddress:(NSString*)eventAddress;
//- (void)checkInDistanceWithEID:(NSString*)eid delegate:(id)receiver;
- (void)checkInDateWithCheckIn:(CheckIn*)check;
- (ASIHTTPRequest*)checkInWithEID:(NSString*)eid uid:(NSString*)uid checkInValue:(NSString*)checkInValue;
- (void)checkInWithEID:(NSString*)eid;
- (void)setAttendanceWithEID:(NSString*)eid confidence:(NSString*)confidence;
- (NSDate*)getDateForEID:(NSString*)eid uid:(NSString*)uid;
- (void)connectivityChanged:(NSNotification*)notice;
- (BOOL)isOnline;
//@property (nonatomic, retain) ASIFormDataRequest *formReq;
//@property (nonatomic, retain) ASIHTTPRequest *httpReq;
@property (nonatomic, retain) NSMutableDictionary *profile;
@property (nonatomic, retain) NSMutableArray *attendingList;
//@property (nonatomic, retain) NSMutableDictionary *attendingDetails;
@property (nonatomic, retain) NSMutableArray *hostingList;
@property (nonatomic, retain) NSMutableDictionary *guestList;
//@property (nonatomic, retain) NSMutableDictionary *hostingDetails;
@property (nonatomic, assign) id<NetworkManagerDelegate> delegate;
@property (nonatomic, retain) Reachability *connectionMonitor;
@end
