//
//  ViewController.m
//  CrunchBaseClientDemo
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "CrunchBaseClient.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CrunchBaseClient requestCompanyWithName:@"AppSocially"
                                     handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {
             
             NSLog(@"error:%@", error);
         }
         else {
             
             NSLog(@"result:%@", result);
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
