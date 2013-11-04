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

#define RESPONSE_FAIL                       400
#define RESPONSE_SUCCESS                    200

#pragma mark - Common

/*
<script type="text/javascript">function resize2(img) {if(img.width >= 300) {img.width = 300;}}</script>
 */

#define LOGIN_ID                            @"LoginID"
#define LOGIN_PASSWORD                      @"LoginPassword"
#define HTML_BODY_SKIN(a)                   [NSString stringWithFormat:@"<html><body><script type=\"text/javascript\">function resize2(img){if(img.width >= 300) {img.width = 300;}}</script>%@</body></html>", a]

#pragma mark - URL

#define URL_LOGIN                           @"http://nikemania.com/members/login.php"
#define URL_LIST                            @"http://nikemania.com/bbs/bbs_list.php"
#define URL_DETAIL                          @"http://nikemania.com/bbs/"


#pragma mark - Request Param

#define KEY_NM_ID                               @"nm_id"
#define KEY_PASSWD                              @"passwd"
#define KEY_IMAGE1_X                            @"image1.x"
#define KEY_IMAGE1_Y                            @"image1.y"
#define KEY_BOARD                               @"bbs"
#define KEY_NUMBER_OF_PAGE                      @"page"
#define KEY_DETAIL_VIEW_URL                     @"detailViewUrl"


#pragma mark - Response Param

#define KEY_STATE                               @"state"
#define KEY_MESSAGE                             @"msg"
#define KEY_LIST                                @"list"
#define KEY_DETAIL_INFO                         @"detailInfo"

#endif
