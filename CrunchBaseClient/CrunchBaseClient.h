//
//  CrunchBaseClient.h
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "AFHTTPClient.h"


@class CLLocation;


@interface CrunchBaseClient : AFHTTPClient

+ (void)setAPIKey:(NSString *)APIKey;

// retrieve a specific company's info
+ (void)companyWithName:(NSString *)companyName
                handler:(void (^)(NSDictionary *result, NSError *error))handler;

// retrieve a specific person's info
+ (void)personWithPermaLink:(NSString *)permaLink
                    handler:(void (^)(NSDictionary *result, NSError *error))handler;

+ (void)personsWithCompanyName:(NSString *)companyName
                       handler:(void (^)(NSArray *result, NSError *error))handler;

// search by location
+ (void)searchByLocation:(CLLocation *)location
                 handler:(void (^)(NSDictionary *result, NSError *error))handler;

+ (void)searchByLocation:(CLLocation *)location
           radiusInMiles:(CGFloat)radiusInMiles
                 handler:(void (^)(NSDictionary *result, NSError *error))handler;

// search by state
+ (void)searchByState:(NSString *)state
              handler:(void (^)(NSDictionary *result, NSError *error))handler;

@end
