//
//  User.h
//  TrueRSVP
//
//  Created by movingincircles on 7/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDelegate <NSObject>
@required
- (void)updatedProfile;
@end

@interface User : NSObject {
    NSString *fullName;
	NSString *email;
	NSString *cell;
	NSString *zip;
	NSString *twitter;
	UIImage *profilePic;
}
+(User*)sharedUser;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *cell;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *twitter;
@property (nonatomic, retain) UIImage *profilePic;
@end
