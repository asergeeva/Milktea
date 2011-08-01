//
//  User.m
//  TrueRSVP
//
//  Created by movingincircles on 7/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//
//#import "Constants.h"
#import "SettingsManager.h"
#import "User.h"
#import "SynthesizeSingleton.h"

@implementation User
SYNTHESIZE_SINGLETON_FOR_CLASS(User);
@synthesize uid;
@synthesize fullName;
@synthesize email;
@synthesize cell;
@synthesize zip;
@synthesize twitter;
@synthesize picURL;
@synthesize profilePic;
@synthesize about;
@synthesize delegate;
- (id)init
{
	if((self = [super init]))
	{
		uid = [[NSMutableString alloc] init];
		fullName = [[NSMutableString alloc] init];
		email = [[NSMutableString alloc] init];
		cell = [[NSMutableString alloc] init];
		zip = [[NSMutableString alloc] init];
		twitter = [[NSMutableString alloc] init];
		about = [[NSMutableString alloc] init];
		picURL = [[NSMutableString alloc] init];
	}
	return self;
}
- (void)updateUser:(NSDictionary*)userInfo
{
	[uid setString:[userInfo objectForKey:@"id"]];
	[fullName setString:[NSString stringWithFormat:@"%@ %@", [userInfo objectForKey:@"fname"], [userInfo objectForKey:@"lname"]]];
	[email setString:[userInfo objectForKey:@"email"]];
	[cell setString:[userInfo objectForKey:@"phone"]];
	[zip setString:[userInfo objectForKey:@"zip"]];
	[about setString:[userInfo objectForKey:@"about"]];
	[twitter setString:[userInfo objectForKey:@"twitter"]];
	[picURL setString:[NSString stringWithFormat:@"%@%@%@%@", [[SettingsManager sharedSettingsManager] rootAddress], @"upload/user/images/", uid, @".png"]];
	NSURL *url = [NSURL URLWithString:picURL];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	request.delegate = self;
	[request startAsynchronous];
	[self.delegate updatedStrings];
}
- (void)requestFinished:(ASIHTTPRequest*)request
{
	
	profilePic = [[UIImage alloc] initWithData:[request responseData]];
	[self.delegate updatedImages];
}
- (void)requestFailed:(ASIHTTPRequest*)request
{
	
}
- (void)dealloc
{
	[fullName release];
	[email release];
	[cell release];
	[zip release];
	[twitter release];
	[profilePic release];
	[about release];
	[picURL release];
	[super dealloc];
}
@end
