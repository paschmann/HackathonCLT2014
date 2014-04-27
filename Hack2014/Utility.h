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

+(void) createAndCheckDatabase;
+(NSString *) getDBPath;

@property(retain) NSString *strDBPath;

@end
