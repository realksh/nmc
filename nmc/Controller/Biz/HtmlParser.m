//
//  HtmlParser.m
//  nmc
//
//  Created by shkim on 2013. 11. 4..
//
//

#import "HtmlParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "ListInfoData.h"
#import "ReplyInfoData.h"

@implementation HtmlParser

+ (TFHpple*)htmlStringToTFHpple:(NSString*)htmlString
{
    NSData* htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    if (!htmlData) {
        return nil;
    }
    
    TFHpple* xpathParser = [[TFHpple alloc]initWithHTMLData:htmlData];
    
    return xpathParser;
}

+ (NSMutableArray*)parseFreeBoardList:(NSString*)responseString
{
    TFHpple* xpathParser = [HtmlParser htmlStringToTFHpple:responseString];
    
    NSArray* arrElement = [xpathParser searchWithXPathQuery:@"//*[@id=\"t_right\"]/table/tr"];
    
    NSMutableArray* arrList = [NSMutableArray array];
    
    for (int i = 1 ; i < arrElement.count ; i++) {
        TFHppleElement *titleElement = [arrElement objectAtIndex:i];
        
        NSString* title     = @"";
        NSString* date      = @"";
        NSString* hits      = @"";
        NSString* url       = @"";
        NSString* nickname  = @"";
        
        NSArray* arrTitle       = [titleElement searchWithXPathQuery:@"//*[@id=\"tsub\"]/a/text()"];
        NSArray* arrDate        = [NSArray arrayWithArray:[titleElement searchWithXPathQuery:@"//*[@id=\"tdate\"]/text()"]];
        NSArray* arrHits        = [titleElement searchWithXPathQuery:@"//*[@id=\"thit\"]/text()"];
        NSArray* arrUrl         = [titleElement searchWithXPathQuery:@"//tr//td[4]//a"];
        NSArray* arrNickname    = [titleElement searchWithXPathQuery:@"//*[@id=\"tid\"]/font/text()"];
        
        if (0 == arrTitle.count || 0 == arrDate.count || 0 == arrHits.count || 0 == arrUrl.count) {
            continue;
        }
        
        if (0 < [arrNickname count]) {
            // nickname
            // string, html 분기 필요.
            TFHppleElement* elementNick = [arrNickname objectAtIndex:0];
            nickname =  [elementNick content];
        }
        
        title       = [(TFHppleElement*)[arrTitle objectAtIndex:0]content];
        date        = [[NSString alloc]initWithString:[(TFHppleElement*)[arrDate objectAtIndex:0]content]];
        hits        = [(TFHppleElement*)[arrHits objectAtIndex:0]content];
        url         = [(TFHppleElement*)[[arrUrl objectAtIndex:0]attributes]objectForKey:@"href"];
        
        /*
        NSLog(@"title : %@", title);
        NSLog(@"date : %@", date);
        NSLog(@"hits : %@", hits);
        NSLog(@"url : %@", url);
        NSLog(@"nickName : %@", nickname);
        */
        ListInfoData* listData = [[ListInfoData alloc]init];
        listData.title = title;
        listData.nickname = nickname;
        listData.date = date;
        listData.hitsCount = hits;
        listData.url = url;
        
        [arrList addObject:listData];
    }
    return arrList;
}

+ (DetailInfoData*)parseDetailWithType:(BoardType)type responseString:(NSString*)responseString
{
    TFHpple* xpathParser = [HtmlParser htmlStringToTFHpple:responseString];
    
    // body
    NSArray* arrBody = [xpathParser searchWithXPathQuery:@"//*[@id=\"con_text\"]"];
    NSString* body = @"";
    
    if (0 < arrBody.count) {
        body  = HTML_BODY_SKIN([[arrBody objectAtIndex:0]raw]);
        body = [body stringByReplacingOccurrencesOfString:@"<img " withString:@"<img width=\"300px\" "];
        
        
        NSLog(@"body :\n%@",body);
    }

//    NSString* title = [[[xpathParser searchWithXPathQuery:@"//*[@id=\"con_head1\"]/strong/font[2]/text()"]objectAtIndex:0]content];
//    NSString* date  = [[[xpathParser searchWithXPathQuery:@"//*[@id=\"con_tail\"]/text()"]objectAtIndex:0]content];
//    NSString* num   = [[[xpathParser searchWithXPathQuery:@"//*[@id=\"con_head1\"]/text()"]objectAtIndex:0]content];
//    NSString* nm_id = [[[xpathParser searchWithXPathQuery:@"//*[@id=\"fid\"]/text()"]objectAtIndex:0]content];
    
    // reply
    
    NSArray* arrReplyElements = [xpathParser searchWithXPathQuery:@"//*[@id=\"rp_right\"]"];
    
    NSMutableArray* arrReplyList = [NSMutableArray array];
    
    for (int i = 0 ; i < arrReplyElements.count - 1 ; i++) {
        
        TFHppleElement* element = [arrReplyElements objectAtIndex:i];
        
        NSArray* arrNickname = [element searchWithXPathQuery:@"//*[@id=\"rp_right\"]/strong/font[1]/font"];
        
        NSString* replyBody     = @"";
        NSString* replyNick     = @"";
        NSString* replyNm_id    = @"";
        NSString* replyDate     = @"";
        
        if (0 < arrNickname.count) {
            replyNick     = [[[element searchWithXPathQuery:@"//*[@id=\"rp_right\"]/strong/font[1]/font/text()"]objectAtIndex:0]content];
        }
        replyBody     = [[[element searchWithXPathQuery:@"//*[@id=\"rp_right\"]/font/text()"]objectAtIndex:0]content];
        if ([replyBody hasPrefix:@"  "]) {
            replyBody = [replyBody substringFromIndex:2];
        }
//        replyNm_id    = [[[element searchWithXPathQuery:@""]objectAtIndex:0]content];
//        replyDate     = [[[element searchWithXPathQuery:@""]objectAtIndex:0]content];
        
        ReplyInfoData* replyInfo = [[ReplyInfoData alloc]init];
        
        replyInfo.body = replyBody;
        replyInfo.nickname = replyNick;
        replyInfo.nm_id = replyNm_id;
        replyInfo.date = replyDate;
        
        [arrReplyList addObject:replyInfo];
    }
    
    DetailInfoData* info = [[DetailInfoData alloc]init];
    
    info.body = body;
//    info.title = title;
//    info.date = date;
//    info.num = num;
//    info.nm_id = nm_id;
    info.replyList = arrReplyList;
    
    return info;
}

@end
