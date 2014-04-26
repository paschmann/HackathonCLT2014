//
//  chart.h
//  Hack2014
//
//  Created by Paul Aschmann on 4/26/14.
//  Copyright (c) 2014 Lithium Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface chart : UIViewController <SChartDatasource>{
    ShinobiChart* _chart;
}
@property (weak, nonatomic) IBOutlet UIButton *cmdClose;
@property (nonatomic, retain) NSMutableArray *dataPoints;
@property (nonatomic, retain) NSMutableArray *labelPoints;
- (IBAction)close:(id)sender;

@end
