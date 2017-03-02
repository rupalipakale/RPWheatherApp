//
//  ViewController.h
//  RPWeatherApplication
//
//  Created by Student P_07 on 25/01/17.
//  Copyright © 2017 Mohsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *locationManager;
    NSArray *arrayList;
    NSDictionary *tempArray;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)goToNext:(id)sender;

@end

