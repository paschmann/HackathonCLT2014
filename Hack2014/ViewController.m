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
    [Utility createAndCheckDatabase];
    arrSuggests = [[NSMutableArray alloc] init];
    db = [FMDatabase databaseWithPath:[Utility getDBPath]];
    [db open];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) getUserInfo2: (NSString *) strURL{
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
                    /*
                    prd = [[prod alloc] init];
                    prd.prodname.text = [row objectAtIndex:1];
                    prd.strProdName = [row objectAtIndex:1];
                
                    prd.view.tag = systemNo;
                    prd.view.frame = CGRectMake(0, ySysLoc, 400, 60);
                    ySysLoc = ySysLoc + 60;
                    scrSuggest.contentSize = CGSizeMake(1000, 1000);
                    prd.view.backgroundColor = [UIColor lightGrayColor];
                    
                    [arrSuggests insertObject:prd atIndex:systemNo];
                    
                    [scrSuggest addSubview: 
                     
                     */
                if (systemNo == 1){
                    prd1.prodname.text = [row objectAtIndex:1];
                    prd1.desc.text = [row objectAtIndex:2];
                    prd1.lastpurch.text = [row objectAtIndex:5];
                    prd1.qty.text = [row objectAtIndex:3];
                } else if (systemNo == 2){
                    prd2.prodname.text = [row objectAtIndex:1];
                    prd2.desc.text = [row objectAtIndex:2];
                    prd2.lastpurch.text = [row objectAtIndex:5];
                    prd2.qty.text = [row objectAtIndex:3];
                }
                else if (systemNo == 3){
                    prd3.prodname.text = [row objectAtIndex:1];
                    prd3.desc.text = [row objectAtIndex:2];
                    prd3.lastpurch.text = [row objectAtIndex:5];
                    prd3.qty.text = [row objectAtIndex:3];
                }
                else if (systemNo == 4){
                    prd4.prodname.text = [row objectAtIndex:1];
                    prd4.desc.text = [row objectAtIndex:2];
                    prd4.lastpurch.text = [row objectAtIndex:5];
                    prd4.qty.text = [row objectAtIndex:3];
                }else if (systemNo == 5){
                    prd5.prodname.text = [row objectAtIndex:1];
                    prd5.desc.text = [row objectAtIndex:2];
                    prd5.lastpurch.text = [row objectAtIndex:5];
                    prd5.qty.text = [row objectAtIndex:3];
                }
                else if (systemNo == 6){
                    prd6.prodname.text = [row objectAtIndex:1];
                    prd6.desc.text = [row objectAtIndex:2];
                    prd6.lastpurch.text = [row objectAtIndex:5];
                    prd6.qty.text = [row objectAtIndex:3];
                }
                
                    systemNo++;
                
                    
                NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO data (HHID, UPC, DESC, FREQ, LAST_PURCH, COUPON_USED, EXPRESS_LANE) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", [row objectAtIndex:0], [row objectAtIndex:1], [row objectAtIndex:2],[row objectAtIndex:3], [row objectAtIndex:5], [row objectAtIndex:4], [row objectAtIndex:6]];
                success =  [db executeUpdate: strQuery];
                _lblHHID.text = [row objectAtIndex:0];
            }
        }
        
        NSLog(@"%@", string);
        NSLog(@"Download Complete");
        [_vueOverlay setHidden:TRUE];
        [self loadSuggestions];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    [networkQueue addOperation:operation];
}

- (IBAction)cmdDownloadSally:(id)sender {
    [self getUserInfo2: @"http://slave02.hackathonclt.org:8889/sallysales"];
}

- (IBAction)cmdDownloadUserDetails:(id)sender {
    [self getUserInfo2: @"http://slave02.hackathonclt.org:8889/stevensales"];
}

- (void) loadSuggestions{
    int ySysLoc = 0;
    int systemNo = 0;
    
    [db open];
    FMResultSet *results;
    
    NSString *strQuery = @"SELECT * FROM data ORDER BY LAST_PURCH";
    results = [db executeQuery:strQuery];
    
    NSString *table = @"";
    
    while([results next]) {
        
        prd = [[prod alloc] init];
        prd.prodname.text = [results stringForColumn:@"UPC"];
        prd.strProdName = [results stringForColumn:@"UPC"];
        
        prd.txtTest.text = @"TEST!";
        
        prd.view.tag = systemNo;
        prd.view.frame = CGRectMake(0, ySysLoc, 400, 60);
        ySysLoc = ySysLoc + 65;
        scrSuggest.contentSize = CGSizeMake(400, ySysLoc);
        prd.view.backgroundColor = [UIColor lightGrayColor];
        
        [arrSuggests insertObject:prd atIndex:systemNo];
        
        [scrSuggest addSubview: prd.view];
        systemNo++;
        prd.prodname.text = @"TEST";
    }
    [db close];

    
}

@end
