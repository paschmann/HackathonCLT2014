//
//  Utility.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject{

}

+(void) showAlert:(NSString *) title message:(NSString *) msg;
+(NSDate*) getDateFromJSON:(NSString *)dateString;

+(NSString *) getWebServiceDBInfo: (NSString *) host: (NSString *) version;
+(NSString *) getWebService: (NSString *) host: (NSString *) version;
+(NSString *) getWebServiceCSRF: (NSString *) host: (NSString *) version;
+(NSString *) encode:(NSData *)plainText;
+(void) createAndCheckDatabase;
+(NSString *) getDBPath;

+(NSString*) getDateFromDate:(NSString *)dateString;

@property(retain) NSString *strDBPath;

@end
