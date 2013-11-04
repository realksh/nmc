//
//  NetworkAPI.h
//  nmc
//
//  Created by shkim on 13. 10. 24..
//
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "NMC_Defines.h"

@interface NetworkAPI : NSObject

+ (void)requestLogin:(NSDictionary *)param
             success:(void (^)(NSDictionary* dic))success
             failure:(void (^)(NSError* error))failure;

+ (void)requestBoardList:(NSDictionary *)param
                    type:(BoardType)type
                 success:(void (^)(NSDictionary* dic))success
                 failure:(void (^)(NSError* error))failure;

+ (void)requestBoardDetail:(NSDictionary *)param
                      type:(BoardType)type
                   success:(void (^)(NSDictionary* dic))success
                   failure:(void (^)(NSError* error))failure;

@end
