//
//  pie.h
//  Hack2014
//
//  Created by Paul Aschmann on 4/26/14.
//  Copyright (c) 2014 Lithium Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>
#import "FMResultSet.h"
#import "FMDatabase.h"

@interface pie : UIViewController <SChartDatasource>{
    ShinobiChart* _chart;
    FMDatabase *db;
    int i;
}


@property (weak, nonatomic) IBOutlet UIView *vuePie;
@property (weak, nonatomic) IBOutlet UIButton *cmdClose;
@property (nonatomic, retain) NSMutableArray *dataPoints;
@property (nonatomic, retain) NSMutableArray *labelPoints;
- (IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vueTop;

@end
