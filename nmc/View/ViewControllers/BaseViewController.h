//
//  BaseViewController.h
//  nmc
//
//  Created by shkim on 13. 10. 23..
//
//

#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"
#import "nmc_defines.h"
#import "MBProgressHUD.h"
#import "NetworkAPI.h"

#define TAG_FOOTER_INDICATOR_VIEW         1000

@interface BaseViewController : UIViewController

@property (strong, nonatomic) NSObject* parameter;

- (BOOL)isSavedLoginId;
- (BOOL)isSavedLoginPw;

- (void)addRevealLeftNavigationBarItem;

@end
