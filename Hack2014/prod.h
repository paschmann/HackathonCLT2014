//
//  prod.h
//  Hack2014
//
//  Created by Paul Aschmann on 4/26/14.
//  Copyright (c) 2014 Lithium Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface prod : UIViewController{
    
}

@property (retain) NSString *strProdName;
@property (weak, nonatomic) IBOutlet UITextField *txtTest;

@property (retain, nonatomic) IBOutlet UILabel *prodname;
@property (retain, nonatomic) IBOutlet UILabel *desc;
@property (retain, nonatomic) IBOutlet UILabel *lastpurch;
@property (retain, nonatomic) IBOutlet UILabel *qty;

@end
