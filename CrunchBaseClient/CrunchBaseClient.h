//
//  CrunchBaseClient.h
//  CompanyScouter
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CrunchBaseClient : AFHTTPClient

+ (CrunchBaseClient *)sharedClient;

+ (void)setAPIKey:(NSString *)APIKey;

+ (void)requestCompanyWithName:(NSString *)name
                       handler:(void (^)(NSDictionary *result, NSError *error))handler;

@end
