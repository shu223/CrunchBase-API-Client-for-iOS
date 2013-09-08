//
//  CrunchBaseClient.m
//  CompanyScouter
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "CrunchBaseClient.h"
#import "AFJSONRequestOperation.h"


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
    
    NSMutableURLRequest *req = [super requestWithMethod:method
                                                   path:path
                                             parameters:nil];
        
    return req;
}

- (void)requestCompanyWithName:(NSString *)name
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


// =============================================================================
#pragma mark - Public

+ (void)setAPIKey:(NSString *)APIKey {
    
    [[CrunchBaseClient sharedClient] setAPIKey:APIKey];
}

+ (void)requestCompanyWithName:(NSString *)name
                       handler:(void (^)(NSDictionary *result, NSError *error))handler
{
    [[CrunchBaseClient sharedClient] requestCompanyWithName:name
                                                    handler:handler];
}

@end
