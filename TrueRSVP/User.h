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
	NSMutableString *uid;
    NSMutableString *fullName;
	NSMutableString *email;
	NSMutableString *cell;
	NSMutableString *zip;
	NSMutableString *twitter;
	NSMutableString *about;
	NSMutableString *picURL;
	UIImage *profilePic;
	id<UserDelegate> delegate;
}
+ (User*)sharedUser;
- (void)updateUser:(NSDictionary*)userInfo;
- (void)updatePic;
@property (nonatomic, retain) NSMutableString *uid;
@property (nonatomic, retain) NSMutableString *fullName;
@property (nonatomic, retain) NSMutableString *email;
@property (nonatomic, retain) NSMutableString *cell;
@property (nonatomic, retain) NSMutableString *zip;
@property (nonatomic, retain) NSMutableString *twitter;
@property (nonatomic, retain) NSMutableString *about;
@property (nonatomic, retain) NSMutableString *picURL;
@property (nonatomic, retain) UIImage *profilePic;
@property (nonatomic, assign) id<UserDelegate> delegate;
@end
