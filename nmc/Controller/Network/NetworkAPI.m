//
//  NetworkAPI.m
//  nmc
//
//  Created by shkim on 13. 10. 24..
//
//

#import "NetworkAPI.h"
#import "AFNetworking.h"
#import "ListInfoData.h"

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
                  dic = @{STATE: @"400",
                          MESSAGE: msg};
              } else if ([@"<meta http-equiv='Refresh' content='0; URL=../index.html'>" isEqualToString:responseString]) {
                  dic = @{STATE: @"200"};
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
                 dic = @{STATE: @"400",
                         MESSAGE: msg};
             } else if ([responseString rangeOfString:@"table class=\"bbslist\""].location != NSNotFound) {
                 // 성공
                 NSMutableArray* arrList = nil;
                 
                 switch (type) {
                     case BoardTypeGeneral: {
                         arrList = [self parseFreeBoard:responseString];
                         break;
                     }
                     default:
                         break;
                 }
                 dic = @{STATE: @"200",
                         LIST: arrList};
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
    NSString* urlString = [param objectForKey:DETAIL_VIEW_URL];
    
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
                 dic = @{STATE: @"400",
                         MESSAGE: msg};
             } else if ([responseString rangeOfString:@"table class=\"bbslist\""].location != NSNotFound) {
                 // 성공
                 NSMutableArray* arrList = nil;
                 
                 switch (type) {
                     case BoardTypeGeneral: {
                         arrList = [self parseFreeBoard:responseString];
                         break;
                     }
                     default:
                         break;
                 }
                 dic = @{STATE: @"200",
                         LIST: arrList};
             }
             
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


+ (NSMutableArray*)parseFreeBoard:(NSString*)responseString
{
    NSData* htmlData = [responseString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    if (!htmlData) {
        return nil;
    }
    
    TFHpple* xpathParser = [[TFHpple alloc]initWithHTMLData:htmlData];

    NSArray* arrElement = [xpathParser searchWithXPathQuery:@"//*[@id=\"t_right\"]/table/tr"];
    
    NSMutableArray* arrList = [NSMutableArray array];
    
    for (int i = 1 ; i < arrElement.count ; i++) {
        TFHppleElement *titleElement = [arrElement objectAtIndex:i];
        
        NSString* title     = @"";
        NSString* date      = @"";
        NSString* hits      = @"";
        NSString* url       = @"";
        NSString* nickname  = @"";
        
        NSArray* arrTitle = [titleElement searchWithXPathQuery:@"//*[@id=\"tsub\"]/a/text()"];
        NSArray* arrDate = [NSArray arrayWithArray:[titleElement searchWithXPathQuery:@"//*[@id=\"tdate\"]/text()"]];
        NSArray* arrHits = [titleElement searchWithXPathQuery:@"//*[@id=\"thit\"]/text()"];
        NSArray* arrUrl = [titleElement searchWithXPathQuery:@"//tr//td[4]//a"];
        NSArray* arrNickname = [titleElement searchWithXPathQuery:@"//*[@id=\"tid\"]/font/text()"];
        
        if (0 < [arrNickname count]) {
            // nickname
            // string, html 분기 필요.
            TFHppleElement* elementNick = [arrNickname objectAtIndex:0];
            nickname =  [elementNick content];
        }
        
        title       = [(TFHppleElement*)[arrTitle objectAtIndex:0]content];
        date       = [[NSString alloc]initWithString:[(TFHppleElement*)[arrDate objectAtIndex:0]content]];
        hits        = [(TFHppleElement*)[arrHits objectAtIndex:0]content];
        url   = [(TFHppleElement*)[[arrUrl objectAtIndex:0]attributes]objectForKey:@"href"];
        
        NSLog(@"title : %@", title);
        NSLog(@"date : %@", date);
        NSLog(@"hits : %@", hits);
        NSLog(@"url : %@", url);
        NSLog(@"nickName : %@", nickname);
        
        ListInfoData* listData = [[ListInfoData alloc]init];
        listData.title = title;
        listData.nickname = nickname;
        listData.date = date;
        listData.hits = hits;
        listData.url = url;
        
        [arrList addObject:listData];
    }
    return arrList;
}

@end
