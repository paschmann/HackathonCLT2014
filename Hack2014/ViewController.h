//
//  ViewController.h
//  Hack2014
//
//  Created by Paul Aschmann on 4/26/14.
//  Copyright (c) 2014 Lithium Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "Utility.h"
#import "prod.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>{
    FMDatabase *db;
    prod *prd;
    __weak IBOutlet UIScrollView *scrSuggest;
    NSMutableArray *arrSuggests;
    __weak IBOutlet UITextView *txtSuggets;
    
    
    __weak IBOutlet UIImageView *imgBG;
    prod *prd1;
    prod *prd2;
    prod *prd3;
    prod *prd4;
    prod *prd5;
    prod *prd6;
}

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;


- (IBAction)cmdDownloadSally:(id)sender;

- (IBAction)cmdDownloadUserDetails:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblHHID;
@property (weak, nonatomic) IBOutlet UILabel *lblLastVisit;
@property (weak, nonatomic) IBOutlet UILabel *lblMostPurchased;

@property (nonatomic, retain) NSArray *responseArray;
@property (weak, nonatomic) IBOutlet UIView *vueOverlay;

@end
