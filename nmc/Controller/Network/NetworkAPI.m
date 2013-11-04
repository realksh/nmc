//
//  NetworkAPI.m
//  nmc
//
//  Created by shkim on 13. 10. 24..
//
//

#import "NetworkAPI.h"
#import "AFNetworking.h"
#import "HtmlParser.h"

@implementation NetworkAPI

#pragma mark - Public API

+ (void)requestLogin:(NSDictionary *)param
             success:(void (^)(NSDictionary* dic))success
             failure:(void (^)(NSError* error))failure
{
    NSString* urlString = URL_LOGIN;

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:urlString
       parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Success :\n%@", [operation responseString]);
              
              NSString* responseString = [operation responseString];
              NSRange range = [responseString rangeOfString:@"script'>alert('"];
              NSDictionary* dic = nil;
              
              if (range.location != NSNotFound) {
                  NSString* msg = [responseString substringFromIndex:range.location+@"script'>alert('".length];
                  NSRange lastRange = [msg rangeOfString:@"');"];
                  msg = [msg substringToIndex:lastRange.location];
                  dic = @{KEY_STATE: @"400",
                          KEY_MESSAGE: msg};
              } else if ([@"<meta http-equiv='Refresh' content='0; URL=../index.html'>" isEqualToString:responseString]) {
                  dic = @{KEY_STATE: @"200"};
              }
              
              success(dic);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Fail :\n%@", error);
              failure(error);
          }];
}

+ (void)requestBoardList:(NSDictionary *)param
                    type:(BoardType)type
                 success:(void (^)(NSDictionary* dic))success
                 failure:(void (^)(NSError* error))failure
{
    NSString* urlString = URL_LIST;
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager GET:urlString
      parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success :\n%@", [operation responseString]);
             
             NSString* responseString = [operation responseString];
             NSRange range = [responseString rangeOfString:@"script'>alert('"];
             NSDictionary* dic = nil;
             
             if (range.location != NSNotFound) {
                 NSString* msg = [responseString substringFromIndex:range.location+@"script'>alert('".length];
                 NSRange lastRange = [msg rangeOfString:@"');"];
                 msg = [msg substringToIndex:lastRange.location];
                 dic = @{KEY_STATE: @"400",
                         KEY_MESSAGE: msg};
             } else if ([responseString rangeOfString:@"table class=\"bbslist\""].location != NSNotFound) {
                 // 성공
                 NSMutableArray* arrList = nil;
                 
                 switch (type) {
                     case BoardTypeGeneral: {
                         arrList = [HtmlParser parseFreeBoardList:responseString];
                         break;
                     }
                     default:
                         break;
                 }
                 dic = @{KEY_STATE: @"200",
                         KEY_LIST: arrList};
             }
             
             success(dic);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Fail :\n%@", error);
             failure(error);
         }];
}

+ (void)requestBoardDetail:(NSDictionary *)param
                      type:(BoardType)type
                   success:(void (^)(NSDictionary* dic))success
                   failure:(void (^)(NSError* error))failure
{
    NSString* urlString = [param objectForKey:KEY_DETAIL_VIEW_URL];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager GET:urlString
      parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success :\n%@", [operation responseString]);
             
             NSString* responseString = [operation responseString];
             
             NSDictionary* dic = nil;
             
             // 성공
             DetailInfoData* info = [HtmlParser parseDetailWithType:type responseString:responseString];
             
             
             dic = @{KEY_STATE: @"200",
                     KEY_DETAIL_INFO: info};
             
             success(dic);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Fail :\n%@", error);
             failure(error);
         }];
}

#pragma mark - Private

+ (NSDictionary*)requestHeaders
{
    NSDictionary* headers = @{@"User-Agent":@"Mozilla/4.0 (compatible;)",
                              @"Referer":@"http://nikemania.com/"};
    return headers;
}



@end
