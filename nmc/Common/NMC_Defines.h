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

#define LOGIN_ID                            @"LoginID"
#define LOGIN_PASSWORD                      @"LoginPassword"

#pragma mark - URL

#define URL_LOGIN                           @"http://nikemania.com/members/login.php"
#define URL_LIST                            @"http://nikemania.com/bbs/bbs_list.php"
#define URL_DETAIL                          @"http://nikemania.com/bbs/bbs_list.php"


#pragma mark - Request Param

#define NM_ID                               @"nm_id"
#define PASSWD                              @"passwd"
#define IMAGE1_X                            @"image1.x"
#define IMAGE1_Y                            @"image1.y"
#define BOARD                               @"bbs"
#define NUMBER_OF_PAGE                      @"page"
#define DETAIL_VIEW_URL                          @"detailViewUrl"


#pragma mark - Response Param

#define STATE                               @"state"
#define MESSAGE                             @"msg"
#define LIST                                @"list"
#define DETAIL_INFO                         @"detailInfo"

#endif
