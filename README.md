#CrunchBase API Client for iOS

In Progress.

##Usage

###Add to your project

Add followings to your project.

- CrunchBaseClient.h, CrunchBaseClient.m
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)


###Set API Key

1. Create an API Key from http://developer.crunchbase.com/.

2. Call `setAPIKey:` method.

````
#import "CrunchBaseClient.h"
````

````
[CrunchBaseClient setAPIKey:@"YOUR API KEY"];
````

##Example

- Retrieve a specific **company**'s information 

````
[CrunchBaseClient requestCompanyWithName:@"appsocially"
                                 handler:
 ^(NSDictionary *result, NSError *error) {
     
     // Do something.
 }];
````

