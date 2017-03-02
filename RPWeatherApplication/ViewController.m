//
//  ViewController.m
//  RPWeatherApplication
//
//  Created by Student P_07 on 25/01/17.
//  Copyright © 2017 Mohsin. All rights reserved.
//
#define kAPIKey @"725aeec82dc39a1a7517b997a0703dd1"
#define kUnitMetric @"metric"
#define kUnitImperial @"imperial"

#import "ViewController.h"
#import "ForecastTableViewCell.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"Weather informaton of 7 days";
    [_activityIndicator startAnimating];
    [self initLocationManager];
    
}
-(void)initLocationManager
{
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    NSLog(@"%f",locationManager.location.coordinate.latitude);

    [self getForecastOfDays:7 APIKey:kAPIKey units:kUnitMetric latitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
}

-(void)getForecastOfDays:(int)day
                  APIKey:(NSString *)key
                   units:(NSString *)unit
                latitude:(double)latitude
               longitude:(double)longitude
{
    NSString *urlString=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&APPID=%@&units=%@&cnt=%d",latitude,longitude,key,unit,day];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        if(error)
            NSLog(@"%@",error.description);
        else
        {
            [_activityIndicator stopAnimating];
            [_activityIndicator setHidden:YES];
            if(response)
            {
                NSError *err;
                NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
            
                 if (httpURLResponse.statusCode == 200) {
                
                   if (data) {

                
                     NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                     arrayList=[dict valueForKey:@"list"];
                      NSLog(@"%@",arrayList);
                     if(arrayList.count>0)
                       [_tblView reloadData];
                      }
                 }
                if(err)
                    NSLog(@"%@",err.localizedDescription);
            }
        }
            
    }];
    [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForecastTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell==nil)
    {
        cell=[[ForecastTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSString *strDay=[NSString stringWithFormat:@"%@",[[arrayList objectAtIndex:indexPath.row]valueForKey:@"dt"]];
    NSLog(@"%@",strDay);
    cell.lblDay.text=[self convertUNIXTimeToDate:strDay];
    //cell.lblDay.text=[NSString stringWithFormat:@"%@",[[[arrayList objectAtIndex:indexPath.row]valueForKey:@"temp"] valueForKey:@"day"]];
    cell.lblMax.text=[NSString stringWithFormat:@"%@ ºC",[[[arrayList objectAtIndex:indexPath.row]valueForKey:@"temp"] valueForKey:@"max"]];
    cell.lblMin.text=[NSString stringWithFormat:@"%@ ºC",[[[arrayList objectAtIndex:indexPath.row]valueForKey:@"temp"] valueForKey:@"min"]];
    return cell;
}

-(NSString *)convertUNIXTimeToDate:(NSString *)dateString {
    NSTimeInterval timeInterval = dateString.doubleValue;
    
    NSDate *weatherDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    dateString = [dateFormatter stringFromDate:weatherDate];
    
    return dateString;
}

-(NSString *)convertUNIXTimeToDay:(NSString *)dateString {
    
    NSTimeInterval timeInterval = dateString.doubleValue;
    
    NSDate *weatherDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    
    dateString = [dateFormatter stringFromDate:weatherDate];
    return dateString;
}

-(NSString *)getTemperatureStringFromString:(NSString *)tempString unit:(NSString *)unit {
    
    if ([unit isEqualToString:kUnitMetric]) {
        int temp = tempString.intValue;
        
        tempString = [NSString stringWithFormat:@"%d °C",temp];
        
        return tempString;
    }
    else if ([unit isEqualToString:kUnitImperial]) {
        int temp = tempString.intValue;
        
        tempString = [NSString stringWithFormat:@"%d °F",temp];
        
        return tempString;
    }
    else {
        int temp = tempString.intValue;
        tempString = [NSString stringWithFormat:@"%d K",temp];
        return tempString;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *secVC=[story instantiateViewControllerWithIdentifier:@"SecondViewController"];
    ForecastTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    secVC.strDay=cell.lblDay.text;
    secVC.strMin=cell.lblMax.text;
    secVC.strMax=cell.lblMin.text;
    secVC.isCurrent=NO;
    [self.navigationController pushViewController:secVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToNext:(id)sender {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *secVC=[story instantiateViewControllerWithIdentifier:@"SecondViewController"];
    secVC.isCurrent=YES;
    [self.navigationController pushViewController:secVC animated:YES];
}
@end
