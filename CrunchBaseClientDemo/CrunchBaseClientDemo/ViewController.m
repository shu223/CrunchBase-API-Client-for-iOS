//
//  ViewController.m
//  CrunchBaseClientDemo
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "CrunchBaseClient.h"
#import "SVProgressHUD.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()
<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UITextView *resultTextView;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =============================================================================
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location:%@", newLocation);
    
    [self.locationManager stopUpdatingLocation];
    
    [CrunchBaseClient searchByLocation:newLocation
                               handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {
             
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
         else if (!result) {
             
             [SVProgressHUD showErrorWithStatus:@"Failed. See logs."];
         }
         else {
             
             self.resultTextView.text = result.description;
             
             [SVProgressHUD showSuccessWithStatus:@"Succeeded!"];
         }
     }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}


// =============================================================================
#pragma mark - IBAction

/**
 sample for retrieving a specific company's information
 */
- (IBAction)retrieveCompanyInfo {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];

    self.resultTextView.text = nil;
    
    [CrunchBaseClient companyWithName:@"appsocially"
                              handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {
             
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
         else {

             self.resultTextView.text = result.description;
             
             [SVProgressHUD showSuccessWithStatus:@"Succeeded!"];
         }
     }];
}

- (IBAction)searchNearby {

    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {

        [SVProgressHUD showWithStatus:@"Loading..."
                             maskType:SVProgressHUDMaskTypeGradient];
        
        self.resultTextView.text = nil;

        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
}

@end
