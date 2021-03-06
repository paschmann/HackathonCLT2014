//
//  ViewController.m
//  Hack2014
//
//  Created by Paul Aschmann on 4/26/14.
//  Copyright (c) 2014 Lithium Labs. All rights reserved.
//

#import "ViewController.h"
#import "prod.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //A basic UIView frame overlay which hides the "template" screen until a user is loaded
    CGRect frame = _vueOverlay.frame;
    frame.origin.y=54;
    frame.origin.x= 234;
    _vueOverlay.frame= frame;
    
    //Create a local sqlite DB to hold the data, mainly used for the Chart
    [Utility createAndCheckDatabase];
    arrSuggests = [[NSMutableArray alloc] init];
    db = [FMDatabase databaseWithPath:[Utility getDBPath]];
    [db open];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Prod1"])
    {
        prd1 = (prod *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"Prod2"]) {
        prd2 = (prod *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"Prod3"]) {
        prd3 = (prod *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"Prod4"]) {
        prd4 = (prod *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"Prod5"]) {
        prd5 = (prod *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"Prod6"]) {
        prd6 = (prod *)segue.destinationViewController;
    }
}



#pragma mark iBeacon Methods

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"lilabs"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"No");
}


-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    NSLog(@"%@", beacon.proximityUUID.UUIDString);
}

#pragma mark Hadoop Data transfer from server to device

- (void) getUserInfo2: (NSString *) strURL{
    //Used to pull the requested VIC Card holders details from the Hadoop System
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        _responseArray = [string componentsSeparatedByString:@"\n"];
        
        //Delete all data in local DB (Probably should be only for that specific VIC customer)
        BOOL success =  [db executeUpdate: @"DELETE FROM DATA"];
        
        int ySysLoc = 0;
        int systemNo = 0;
        
        for (int i = 0; i < _responseArray.count -1; i++){
            
            NSArray *row = [[_responseArray objectAtIndex:i] componentsSeparatedByString:@"|"];
            if (![[row objectAtIndex:0] isEqualToString:@"HHID"] && ![[row objectAtIndex:1] isEqualToString:@"0"]){
                NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO data (HHID, UPC, DESC, FREQ, LAST_PURCH, COUPON_USED, EXPRESS_LANE) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", [row objectAtIndex:0], [row objectAtIndex:1], [row objectAtIndex:2],[row objectAtIndex:3], [row objectAtIndex:5], [row objectAtIndex:4], [row objectAtIndex:6]];
                success =  [db executeUpdate: strQuery];
                _lblHHID.text = [row objectAtIndex:0];
            }
        }
        
        [self getLatestShop];
        [self getMostPurchasedProduct];
        NSLog(@"Download Complete");
        [_vueOverlay setHidden:TRUE];
        [self loadSuggestions];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    [networkQueue addOperation:operation];
}


- (void) getUserInfoDetails: (NSString *) strURL{
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        _responseArray = [string componentsSeparatedByString:@"\n"];
        
        BOOL success =  [db executeUpdate: @"DELETE FROM DATA"];
        
        int ySysLoc = 0;
        int systemNo = 0;
        
        for (int i = 0; i < _responseArray.count -1; i++){
            
            NSArray *row = [[_responseArray objectAtIndex:i] componentsSeparatedByString:@"|"];
            if (![[row objectAtIndex:0] isEqualToString:@"HHID"] && ![[row objectAtIndex:1] isEqualToString:@"0"]){
                _lblHHID.text = [row objectAtIndex:0];
            }
        }
        
        [self getLatestShop];
        NSLog(@"%@", string);
        NSLog(@"Download Complete");
        [_vueOverlay setHidden:TRUE];
        [self loadSuggestions];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    [networkQueue addOperation:operation];
}

#pragma mark Local DB Calls for different info

- (void) getLatestShop{
    //Get the last time the user was in the store from our local DB
    NSString *strQuery = @"SELECT max(last_punch) FROM data";
    [db open];
    FMResultSet *results;
    results = [db executeQuery:strQuery];
    
    while([results next]) {
        _lblLastVisit.text = [NSString stringWithFormat:@"Last Visit: %@", [results stringForColumn:@"Last_purch"]];
    }
    
    NSLog(@"%@", db.lastError);
}

- (void) getMostPurchasedProduct{
    //Get the last time the user was in the store from our local DB
    NSString *strQuery = @"SELECT UPC, max(last_punch) FROM data";
    [db open];
    FMResultSet *results;
    results = [db executeQuery:strQuery];
    
    while([results next]) {
        _lblMostPurchased.text = [NSString stringWithFormat:@"Most Product Purchased: %@", [results stringForColumn:@"UPC"]];
    }
    
    NSLog(@"%@", db.lastError);
}



- (void) loadSuggestions{
    //Load suggested products in their respective views (We only show top 6 suggested products). These should probably also go into dynamic views rather than static
    int systemNo = 0;
    
    [db open];
    FMResultSet *results;
    
    NSString *strQuery = @"SELECT * FROM data ORDER BY LAST_PURCH";
    results = [db executeQuery:strQuery];
    
    while([results next]) {
        prd.prodname.text = [results stringForColumn:@"UPC"];
        
        if (systemNo == 1){
            prd1.prodname.text = [results stringForColumn:@"UPC"];
            prd1.desc.text = [results stringForColumn:@"DESC"];
            prd1.lastpurch.text = [results stringForColumn:@"LAST_PURCH"];
            prd1.qty.text = [results stringForColumn:@"FREQ"];
        } else if (systemNo == 2){
            prd2.prodname.text = [results stringForColumn:@"UPC"];
            prd2.desc.text = [results stringForColumn:@"DESC"];
            prd2.lastpurch.text = [results stringForColumn:@"LAST_PURCH"];
            prd2.qty.text = [results stringForColumn:@"FREQ"];        }
        else if (systemNo == 3){
            prd3.prodname.text = [results stringForColumn:@"UPC"];
            prd3.desc.text = [results stringForColumn:@"DESC"];
            prd3.lastpurch.text = [results stringForColumn:@"LAST_PURCH"];
            prd3.qty.text = [results stringForColumn:@"FREQ"];
        }
        else if (systemNo == 4){
            prd4.prodname.text = [results stringForColumn:@"UPC"];
            prd4.desc.text = [results stringForColumn:@"DESC"];
            prd4.lastpurch.text = [results stringForColumn:@"LAST_PURCH"];
            prd4.qty.text = [results stringForColumn:@"FREQ"];
        }else if (systemNo == 5){
            prd5.prodname.text = [results stringForColumn:@"UPC"];
            prd5.desc.text = [results stringForColumn:@"DESC"];
            prd5.lastpurch.text = [results stringForColumn:@"LAST_PURCH"];
            prd5.qty.text = [results stringForColumn:@"FREQ"];
        }
        else if (systemNo == 6){
            prd6.prodname.text = [results stringForColumn:@"UPC"];
            prd6.desc.text = [results stringForColumn:@"DESC"];
            prd6.lastpurch.text = [results stringForColumn:@"LAST_PURCH"];
            prd6.qty.text = [results stringForColumn:@"FREQ"];
        }
        
        systemNo++;
        
    }
}


#pragma mark UI Methods

- (IBAction)cmdDownloadSally:(id)sender {
    //Sally - In this case we assume their data is from the HHID:
    [self getUserInfo2: @"http://slave02.hackathonclt.org:8890/sallysales"];
    imgBG.image = [UIImage imageNamed:@"bgSally.png"];
}

- (IBAction)cmdDownloadUserDetails:(id)sender {
    //Steven's Data - In this case we assume their data is from the HHID:
    [self getUserInfo2: @"http://slave02.hackathonclt.org:8890/stevensales"];
    imgBG.image = [UIImage imageNamed:@"bg.png"];
}


@end
