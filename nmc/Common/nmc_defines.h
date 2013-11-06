//
//  NMC_Defines.h
//  nmc
//
//  Created by shkim on 13. 10. 23..
//
//

#ifndef nmc_NMC_Defines_h
#define nmc_NMC_Defines_h

#pragma mark - Enum Type

typedef enum {
    BoardTypeGeneral
}BoardType;

typedef enum {
    RequestTypeLogin,
    RequestTypeLogout,
    RequestTypeList
}RequestType;


#pragma mark - Response State

#define RESPONSE_FAIL                       @"400"
#define RESPONSE_SUCCESS                    @"200"
#define RESPONSE_NOT_LOGIN                  @"300"

#pragma mark - Common

/*
<script type="text/javascript">function resize2(img) {if(img.width >= 300) {img.width = 300;}}</script>
 */

#define LOGIN_ID                                @"LoginID"
#define LOGIN_PASSWORD                          @"LoginPassword"
//#define HTML_BODY_SKIN(a)                       [NSString stringWithFormat:@"<html><head><style type=\"text/css\"> body {font-family:\"Apple SD Gothic Neo\"; font-size: 11pt;}</style></head><body><script type=\"text/javascript\">function resize2(img){if(img.width >= 300) {img.width = 300;}}</script>%@</body></html>", a]
#define HTML_BODY_SKIN(a)                       [NSString stringWithFormat:@"<html><head><style type=\"text/css\"> body {font-family:\"Apple SD Gothic Neo\"; font-size: 11pt;}</style></head><body>%@</body></html>", a]
#pragma mark - URL

#define URL_LOGIN                               @"http://nikemania.com/members/login.php"
#define URL_LIST                                @"http://nikemania.com/bbs/bbs_list.php"
#define URL_DETAIL                              @"http://nikemania.com/bbs/"


#pragma mark - Request Param

#define KEY_NM_ID                               @"nm_id"
#define KEY_PASSWD                              @"passwd"
#define KEY_IMAGE1_X                            @"image1.x"
#define KEY_IMAGE1_Y                            @"image1.y"
#define KEY_BOARD                               @"bbs"
#define KEY_NUMBER_OF_PAGE                      @"page"
#define KEY_DETAIL_VIEW_URL                     @"detailViewUrl"
#define KEY_PAGE                                @"page"


#pragma mark - Response Param

#define KEY_STATE                               @"state"
#define KEY_MSG                                 @"msg"
#define KEY_LIST                                @"list"
#define KEY_DETAIL_INFO                         @"detailInfo"


#pragma mark - Colors

#define COLOR_NMC_SKY           [UIColor colorWithRed:153.0f/255.0f green:204.0f/255.0f blue:251.0f/255.0f alpha:1]

#pragma mark - Strings

static NSString* kStrAlertTitle = @"NMC";
static NSString* kStrAlertMsgNotLogin = @"장시간 사용하지 않아 로그아웃 되었습니다.";
static NSString* kStrAlertResponseFail = @"연결에 실패하였습니다.";

#endif
