//
//  DetailInfoData.h
//  nmc
//
//  Created by shkim on 2013. 10. 29..
//
//

#import <Foundation/Foundation.h>

@interface DetailInfoData : NSObject

@property (nonatomic, strong) NSString* nickname;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* date;
@property (nonatomic, strong) NSString* num;
@property (nonatomic, strong) NSString* numberOfReply;
@property (nonatomic, strong) NSString* platform;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* hits;
@property (nonatomic, strong) NSString* body;

@property (nonatomic, strong) NSArray* replyList;

@end
