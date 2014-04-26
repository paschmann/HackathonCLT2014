//
//  Utility.m
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import "Utility.h"
#import "AFNetworking.h"
#import "AFNetworking.h"


static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation Utility

+(NSString *)encode:(NSData *)plainText {
    long encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;
    unsigned char *outputBuffer = malloc(encodedLength);
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];
    
    NSInteger i;
    NSInteger j = 0;
    long remain;
    
    for(i = 0; i < [plainText length]; i += 3) {
        remain = [plainText length] - i;
        
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];
        
        if(remain > 1)
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
        else
            outputBuffer[j++] = '=';
        
        if(remain > 2)
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
        else
            outputBuffer[j++] = '=';
    }
    
    outputBuffer[j] = 0;
    
    NSString *result = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer);
    
    return result;
}


+(NSString *) getDatabasePath
{
    //NSString *databasePath = [(proxAppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    //return databasePath;
    return @"";
}

+(void) showAlert:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}


+(NSDate*) getDateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    long startPos = [dateString rangeOfString:@"("].location + 1;
    long endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

+(NSString*) getDateFromDate:(NSString *)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm:ss.SSS"];

    NSDate *date = [dateFormat dateFromString:dateString];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    [newDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *newString = [newDateFormatter stringFromDate:date];
    return newString;
}


+(NSString *) getWebServiceDBInfo: (NSString *) host: (NSString *) version{
    NSString *strURL = [NSString stringWithFormat:@"%@%@", host, @"/sap/hana/xs/ide/editor/server/dbinfo.xsjs"];
    return strURL;
}


+(NSString *) getWebServiceCSRF: (NSString *) host: (NSString *) version{
    NSString *strURL = [NSString stringWithFormat:@"%@%@", host, @"/sap/hana/xs/formLogin/token.xsjs"];
    return strURL;
}


+(NSString *) getWebService: (NSString *) host: (NSString *) version{
    NSString *strURL = [NSString stringWithFormat:@"%@%@", host, @"/sap/hana/ide/core/base/server/net.xsjs"];
    return strURL;
}


+(NSString *) getDBPath{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"hack.sqlite"];
    
}

+(void) createAndCheckDatabase
{
    NSString *documentsFolder          = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseFullDocumentPath = [documentsFolder stringByAppendingPathComponent:@"hack.sqlite"];
    NSString *databaseFullBundlePath   = [[NSBundle mainBundle] pathForResource:@"hack.sqlite" ofType:@""];
    NSLog(@"%@", databaseFullBundlePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:databaseFullDocumentPath])
    {
        NSAssert([fileManager fileExistsAtPath:databaseFullBundlePath], @"Database not found in bundle");
        
        NSError *error;
        if (![fileManager copyItemAtPath:databaseFullBundlePath toPath:databaseFullDocumentPath error:&error])
            NSLog(@"Unable to copy database from '%@' to '%@': error = %@", databaseFullBundlePath, databaseFullDocumentPath, error);
    }
    
}




@end
