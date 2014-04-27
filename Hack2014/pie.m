//
//  pie.m
//  Hack2014
// Class handles the pie view, (not completed)
//  Created by Paul Aschmann on 4/26/14.
//  Copyright (c) 2014 Lithium Labs. All rights reserved.
//


#import "pie.h"
#import "Utility.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface pie ()

@end

@implementation pie

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self clear];
    db = [FMDatabase databaseWithPath:[Utility getDBPath]];
    [db open];
    FMResultSet *results;
    
    NSString *strQuery = @"SELECT UPC, SUM(FREQ) 'frq' FROM data GROUP BY UPC ORDER BY FREQ DESC";
    results = [db executeQuery:strQuery];
    
    NSString *table = @"";
    
    while([results next]) {
        [_dataPoints addObject: [NSNumber numberWithInteger:[results intForColumn:@"frq"]]];
        [_labelPoints addObject: [results stringForColumn:@"UPC"]];
    }
    [db close];
    [self setupShinobi];
}

- (void) clear{
    _dataPoints = [[NSMutableArray alloc] init];
    _labelPoints = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void) setupShinobi{
    CGFloat margin = 5.0;
    _chart = nil;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);
    _chart.canvasInset = titleInsets;
    
    _chart.licenseKey = @"H8UZ4vyhXb4oX5GMjAxNDA1MTVwYXNjaG1hbm5AbGktbGFicy5jb20=7QEVvdVcmlqHxno63H3qlldzSV0ADeo/9yRwbdOZSAsb2m1SuEAD5uIRPcvsTniYuBnvtOGkN8V5tpNMpaljuKvg/D/UdupzVS9jSF8i26vRow6YG9SKK0VcQ9LdzBl/4sWJdNctReZuGFkc4DzKC2mvQMas=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    _chart.autoresizingMask = ~UIViewAutoresizingNone;
    _chart.backgroundColor = [UIColor whiteColor];
    
    // add a pair of axes
    //SChartDateTimeAxis *xAxis = [[SChartDateTimeAxis alloc] init];
    SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
    _chart.xAxis = xAxis;
    
    SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init];
    _chart.yAxis = yAxis;
    yAxis.style.majorTickStyle.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.0f];
    
    // enable gestures
    yAxis.enableGesturePanning = YES;
    yAxis.enableGestureZooming = YES;
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    
    xAxis.style.majorTickStyle.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.0f];
    _chart.yAxis.style.majorTickStyle.labelColor = [UIColor lightGrayColor];
    _chart.xAxis.style.majorTickStyle.labelColor = [UIColor lightGrayColor];
    
    xAxis.style.lineWidth = @0;
    yAxis.style.lineWidth = @0;
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    /*
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
     */
    
    //lineSeries.title = [dateFormatter stringFromDate: [_labelPoints objectAtIndex:index]];;
    lineSeries.title = [_labelPoints objectAtIndex:index];
    lineSeries.style.lineColor = Rgb2UIColor(64, 184, 255);
    lineSeries.style.lineWidth = @3;
    //lineSeries.style.showFill = YES;
    
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return [_dataPoints count] - 1;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    // both functions share the same x-values
    datapoint.xValue = [NSNumber numberWithInt:i];
    i++;
    
    // compute the y-value for each series
    datapoint.yValue = [_dataPoints objectAtIndex:dataIndex];
    
    return datapoint;
}


@end
