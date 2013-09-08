//
//  CrunchBaseClient.m
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "CrunchBaseClient.h"
#import "AFJSONRequestOperation.h"
#import <CoreLocation/CoreLocation.h>


#define API_BASE_URL      @"http://api.crunchbase.com/v/1/"


@interface CrunchBaseClient ()
@property (nonatomic) NSString *APIKey;
@end


@implementation CrunchBaseClient

+ (CrunchBaseClient *)sharedClient
{
    static CrunchBaseClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[CrunchBaseClient alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    });
    
    return sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"Accept"     value:@"application/json"];
    }
    
    return self;
}


// =============================================================================
#pragma mark - Private

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSAssert(self.APIKey, @"API Key has not been set.\n\n");

    path = [path stringByAppendingFormat:@"?api_key=%@", self.APIKey];
    
    if ([parameters count]) {
        
        for (NSString *key in [parameters keyEnumerator]) {
            
            NSString *value = [NSString stringWithFormat:@"%@",
                               [parameters valueForKey:key]];
            
            NSAssert2([key length] && [value length],
                      @"invalid param! key:%@: value:%@", key, value);
            
            path = [path stringByAppendingFormat:@"&%@=%@", key, value];
        }
    }
    
    NSMutableURLRequest *req = [super requestWithMethod:method
                                                   path:path
                                             parameters:nil];
        
    return req;
}

- (void)companyWithName:(NSString *)name
                handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    NSAssert([name length], @"name is required");
    
    __weak CrunchBaseClient *weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

        NSString *path = [NSString stringWithFormat:@"company/%@.js", name];

        [weakSelf getPath:path
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(responseObject, nil);
                      });
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(nil, error);
                      });
                  }];
    });
}

- (void)searchByLocation:(CLLocation *)location
           radiusInMiles:(CGFloat)radiusInMiles
                 handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    NSAssert(location, @"location is required");
    
    __weak CrunchBaseClient *weakSelf = self;
    
    // Get Postal Code by reverse-geocoding
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         if (error) {
             
             handler(nil, error);
             
             return;
         }
         
         if (![placemarks count]) {
             
             NSLog(@"no placemarks");
             
             handler(nil, nil);
             
             return;
         }
         
         CLPlacemark *placemark = (CLPlacemark *)[placemarks lastObject];
         
         NSLog(@"ReverseGeocode result:%@", placemark);
         
         if (![placemark.postalCode length]) {
             
             NSLog(@"no postal code");
             
             handler(nil, nil);
             
             return;
         }
         
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_async(queue, ^{
             
             NSString *path = @"search.js";
             NSDictionary *params = @{@"geo": placemark.postalCode,
                                      @"range": @(radiusInMiles)};
             
             [weakSelf getPath:path
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               handler(responseObject, nil);
                           });
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               handler(nil, error);
                           });
                       }];
         }); 
     }];
}

- (void)searchByState:(NSString *)state
                 handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    NSAssert(state, @"location is required");
    
    __weak CrunchBaseClient *weakSelf = self;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString *path = @"search.js";
        NSDictionary *params = @{@"geo": state};
        
        [weakSelf getPath:path
               parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(responseObject, nil);
                      });
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          handler(nil, error);
                      });
                  }];
    });
}


// =============================================================================
#pragma mark - Public

+ (void)setAPIKey:(NSString *)APIKey {
    
    [[CrunchBaseClient sharedClient] setAPIKey:APIKey];
}

+ (void)companyWithName:(NSString *)name
                handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    [[CrunchBaseClient sharedClient] companyWithName:name
                                             handler:handler];
}

+ (void)searchByLocation:(CLLocation *)location
                 handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    [[CrunchBaseClient sharedClient] searchByLocation:location
                                        radiusInMiles:20.0
                                              handler:handler];
}

+ (void)searchByState:(NSString *)state
                 handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    [[CrunchBaseClient sharedClient] searchByState:state
                                              handler:handler];
}

@end
