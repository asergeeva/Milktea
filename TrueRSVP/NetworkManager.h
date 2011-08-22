//
//  SharedNetwork.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class CheckIn;
@class Reachability;
@class Event;
@class OAuth;
@class ASIFormDataRequest;
@class ASIHTTPRequest;
//@class ASINetworkQueue;
@protocol NetworkManagerDelegate
@optional
- (void)progressCheck;
- (void)offlineMode;
@end
@interface NetworkManager : NSObject
{
//	ASIFormDataRequest *formReq;
//	ASIHTTPRequest *httpReq;
	NSMutableDictionary *profile;
	NSMutableArray *attendingList;
	NSMutableArray *hostingList;
	NSMutableDictionary *sm;
	NSMutableDictionary *guestList;
	BOOL profileDone;
	BOOL attendingDone;
	BOOL hostingDone;
	Reachability *r;
	id<NetworkManagerDelegate> delegate;
	Reachability *connectionMonitor;
//	ASINetworkQueue *allQueue;
}
+ (NetworkManager*)sharedNetworkManager;
- (void)didFinishLoadProfile:(ASIFormDataRequest*)request;
- (void)didFinishLoadHosting:(ASIFormDataRequest*)request;
- (void)didFinishLoadAttending:(ASIFormDataRequest*)request;
- (void)didFailLoadProfile:(ASIFormDataRequest*)request;
- (void)didFailLoadHosting:(ASIFormDataRequest*)request;
- (void)didFailLoadAttending:(ASIFormDataRequest*)request;

//- (void)refreshAll:(UIProgressView*)bar;
- (void)refreshAll:(UIProgressView*)bar;
- (BOOL)checkFilled;
- (BOOL)isSessionAlive;
- (void)processQueue;

- (void)getScoreWithEID:(NSString*)eid delegate:(UIViewController*)viewController finishedSelector:(SEL)finished failedSelector:(SEL)failed;
- (void)getMapWithAddress:(NSString*)eventAddress delegate:(UIViewController*)viewController finishedSelector:(SEL)finished failedSelector:(SEL)failed;
- (ASIHTTPRequest*)getOrganizerEmailForOrganizerID:(NSString*)oid;
- (void)updateProfileWithEmail:(NSString*)email about:(NSString*)about cell:(NSString*)cell zip:(NSString*)zip twitter:(NSString*)twitter delegate:(UIViewController*)viewController;
- (CLLocationCoordinate2D)getCoordsFromAddress:(NSString*)eventAddress;
- (void)checkInDateWithCheckIn:(CheckIn*)check;
- (ASIHTTPRequest*)checkInWithEID:(NSString*)eid uid:(NSString*)uid checkInValue:(NSString*)checkInValue;
- (void)uploadPhoto:(NSData*)imageData oauth:(OAuth*)oAuth delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed;
- (void)checkInWithEID:(NSString*)eid;
- (void)setAttendanceWithEID:(NSString*)eid confidence:(NSString*)confidence;
- (NSDate*)getDateForEID:(NSString*)eid uid:(NSString*)uid;
- (void)connectivityChanged:(NSNotification*)notice;
- (void)updateStreamWithEID:(NSString*)eid delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed;
- (void)sendMessageWithEventName:(NSString*)eventName eid:(NSString*)eid content:(NSString*)message selectionList:(NSArray*)selectedFromList messageType:(NSString*)type delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed;
- (BOOL)isOnline;

@property (nonatomic, retain) NSMutableDictionary *profile;
@property (nonatomic, retain) NSMutableArray *attendingList;
@property (nonatomic, retain) NSMutableArray *hostingList;
@property (nonatomic, retain) NSMutableDictionary *guestList;
@property (nonatomic, assign) id<NetworkManagerDelegate> delegate;
@property (nonatomic, retain) Reachability *connectionMonitor;
@end
