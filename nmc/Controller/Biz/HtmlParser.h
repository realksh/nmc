//
//  HtmlParser.h
//  nmc
//
//  Created by shkim on 2013. 11. 4..
//
//

#import <Foundation/Foundation.h>
#import "NMC_Defines.h"
#import "DetailInfoData.h"

@interface HtmlParser : NSObject

+ (NSMutableArray*)parseFreeBoardList:(NSString*)responseString;
+ (DetailInfoData*)parseDetailWithType:(BoardType)type responseString:(NSString*)responseString;

@end
