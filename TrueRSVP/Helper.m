//
//  Helper.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "Helper.h"
#import <CommonCrypto/CommonDigest.h>
@implementation Helper

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
+ (NSString*)stringToMD5String:(NSString*)txtPassword
{
	//MD5 encryption code
	NSString *str = txtPassword;
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	str = [NSString stringWithFormat:
		   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
		   result[0], result[1], result[2], result[3], 
		   result[4], result[5], result[6], result[7],
		   result[8], result[9], result[10], result[11],
		   result[12], result[13], result[14], result[15]
		   ]; 
	return str;
}
@end
