//
//  BaseViewController.h
//  nmc
//
//  Created by shkim on 13. 10. 23..
//
//

#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"
#import "NMC_Defines.h"
#import "MBProgressHUD.h"
#import "NetworkAPI.h"

@interface BaseViewController : UIViewController

@property (strong, nonatomic) NSObject* parameter;

- (BOOL)isSavedLoginId;
- (BOOL)isSavedLoginPw;

- (void)addRevealLeftNavigationBarItem;

@end
