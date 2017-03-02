//
//  SecondViewController.m
//  RPWeatherApplication
//
//  Created by Student P_07 on 27/01/17.
//  Copyright © 2017 Mohsin. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Current day weather information";
    if (self.isCurrent) {
        self.title=@"Current day weather information";

        [self getCurrentWeatherData];
    }
    else
    {
        self.title=@"Weather information";

        self.lblDay.text=_strDay;
        self.lblMax.text=_strMax;
        self.lblMin.text=_strMin;
        [self.activityIndicatorCurrentWeather stopAnimating];
        [self.activityIndicatorCurrentWeather setHidden:YES];
    }
}

-(void)getCurrentWeatherData
{
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];

    [locationManager startUpdatingLocation];
    [self getCurrentWeatherWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
}

-(void)getCurrentWeatherWithLatitude:(double)latitude
                           longitude:(double)longitude {
    
    [self.activityIndicatorCurrentWeather startAnimating];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=725aeec82dc39a1a7517b997a0703dd1&units=metric",latitude,longitude];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *myTask = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
                
                if (httpURLResponse.statusCode == 200) {
                    
                    if (data) {
                        
                        NSError *error;
                        dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        [self showDataOnLabel];
                        
                        if (error) {
                            NSLog(@"%@",error.localizedDescription);
                        }
                        else {
                            
                            
                        }
                        
                    }
                }
            }
        }
    }];
    
    
    [myTask resume];
    
}

-(void)showDataOnLabel
{
    [self.activityIndicatorCurrentWeather stopAnimating];
    [self.activityIndicatorCurrentWeather setHidden:YES];
    self.lblDay.text=[self convertUNIXTimeToDate:[NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"dt"] ]];
    self.lblMax.text=[NSString stringWithFormat:@"%@ ºC",[[dataDictionary valueForKey:@"main"] valueForKey:@"temp_max"]];
    self.lblMin.text=[NSString stringWithFormat:@"%@ ºC",[[dataDictionary valueForKey:@"main"] valueForKey:@"temp_min"]];
}


-(NSString *)convertUNIXTimeToDate:(NSString *)dateString {
    NSTimeInterval timeInterval = dateString.doubleValue;
    
    NSDate *weatherDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    dateString = [dateFormatter stringFromDate:weatherDate];
    
    return dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
