//
//  LoginViewController.h
//  nmc
//
//  Created by shkim on 13. 10. 22..
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol LoginViewDelegate <NSObject>

@optional
- (void)dismissLoginViewController;

@end

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) id<LoginViewDelegate> delegate;

@end
