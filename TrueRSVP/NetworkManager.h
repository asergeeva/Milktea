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
- (void)progressFinished;
- (void)offlineMode;
@end

@protocol NetworkManagerProfileDelegate
@required
- (void)updateProfile;
@end

@protocol NetworkManagerAttendingDelegate
@required
- (void)updateAttending;
@end

@protocol NetworkManagerHostingDelegate
@required
- (void)updateHosting;
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
	NSUserDefaults *ud;
	BOOL profileDone;
	BOOL attendingDone;
	BOOL hostingDone;
	BOOL refreshTimer;
	Reachability *r;
	id<NetworkManagerDelegate> delegate;
	id<NetworkManagerProfileDelegate> profileDelegate;
	id<NetworkManagerHostingDelegate> hostingDelegate;
	id<NetworkManagerAttendingDelegate> attendingDelegate;
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
- (void)refreshAllWithDelegate:(UIViewController*)receiver completion:(SEL)finished;
- (BOOL)checkFilled;
- (BOOL)isSessionAlive;
- (void)processQueue;
- (int)getAttendanceForEvent:(NSString*)eid;
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
- (void)updateStreamWithHashtag:(NSString*)hashtag delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed;
- (void)sendMessageWithEventName:(NSString*)eventName eid:(NSString*)eid content:(NSString*)message selectionList:(NSArray*)selectedFromList messageType:(NSString*)type delegate:(UIViewController*)receiver finishedSelector:(SEL)finished failedSelector:(SEL)failed;
- (NSString*)getUsernameWithUID:(NSString*)uid;
- (BOOL)isOnline;
- (void)uploadProfilePicWithImage:(UIImage*)image filename:(NSString*)filename delegate:(UIViewController*)receiver finishedSelector:(SEL)finish;
- (void)checkInWithEID:(NSString*)eid;
- (void)checkInWithEID:(NSString*)eid showErrorNotification:(BOOL)showNotification;
- (void)isCheckedInWithEID:(NSString*)eid didFinish:(SEL)finished delegate:(id)receiver;
@property (nonatomic, retain) NSMutableDictionary *profile;
@property (nonatomic, retain) NSMutableArray *attendingList;
@property (nonatomic, retain) NSMutableArray *hostingList;
@property (nonatomic, retain) NSMutableDictionary *guestList;
@property (nonatomic, assign) id<NetworkManagerDelegate> delegate;
@property (nonatomic, assign) id<NetworkManagerProfileDelegate> profileDelegate;
@property (nonatomic, assign) id<NetworkManagerAttendingDelegate> attendingDelegate;
@property (nonatomic, assign) id<NetworkManagerHostingDelegate> hostingDelegate;
@property (nonatomic, retain) Reachability *connectionMonitor;
@end
