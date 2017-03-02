//
//  SecondViewController.h
//  RPWeatherApplication
//
//  Created by Student P_07 on 27/01/17.
//  Copyright © 2017 Mohsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSDictionary *dataDictionary;
}

@property BOOL isCurrent;
@property(strong,nonatomic)NSString *strDay;
@property(strong,nonatomic)NSString *strMin;
@property(strong,nonatomic)NSString *strMax;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorCurrentWeather;

@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblMin;
@property (strong, nonatomic) IBOutlet UILabel *lblMax;

@end
