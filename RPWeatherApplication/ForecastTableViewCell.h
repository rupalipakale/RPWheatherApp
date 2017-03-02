//
//  ForecastTableViewCell.h
//  RPWeatherApplication
//
//  Created by Student P_07 on 25/01/17.
//  Copyright © 2017 Mohsin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblMin;
@property (strong, nonatomic) IBOutlet UILabel *lblMax;

@end
