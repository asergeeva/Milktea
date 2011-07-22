//
//  User.h
//  TrueRSVP
//
//  Created by movingincircles on 7/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@protocol UserDelegate
@optional
- (void)updatedStrings;
- (void)updatedImages;
@end

@interface User : NSObject <ASIHTTPRequestDelegate> {
	NSString *uid;
    NSString *fullName;
	NSString *email;
	NSString *cell;
	NSString *zip;
	NSString *twitter;
	NSString *about;
	UIImage *profilePic;
	id<UserDelegate> delegate;
}
+ (User*)sharedUser;
- (void)updateUser:(NSDictionary*)userInfo;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *cell;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *twitter;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) UIImage *profilePic;
@property (nonatomic, assign) id<UserDelegate> delegate;
@end
