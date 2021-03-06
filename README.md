#CrunchBase API Client for iOS

In Progress.

##Usage

###1. Add CrunchBase Client to your project

Add followings to your project.

- CrunchBaseClient.h, CrunchBaseClient.m
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)


###2. Set API Key

You can create your API Key from [http://developer.crunchbase.com/](http://developer.crunchbase.com/).

````
#import "CrunchBaseClient.h"
````

````
[CrunchBaseClient setAPIKey:@"YOUR API KEY"];
````

##Examples

- Retrieve a specific **company**'s information 

````
[CrunchBaseClient companyWithName:@"appsocially"
                          handler:
 ^(NSDictionary *result, NSError *error) {
     
     // Do something.
 }];
````

- Search by **location** (CLLocation object)

````
[CrunchBaseClient searchByLocation:location
                     radiusInMiles:50.0
                           handler:
 ^(NSDictionary *result, NSError *error) {
     
     // Do something.
 }];
````

- Search by **state**

````
[CrunchBaseClient searchByState:@"CA"
                          handler:
 ^(NSDictionary *result, NSError *error) {
     
     // Do something.
 }];
````


##License

MIT License