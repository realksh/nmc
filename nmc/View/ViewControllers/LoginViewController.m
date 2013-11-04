//
//  LoginViewController.m
//  nmc
//
//  Created by shkim on 13. 10. 22..
//
//

#import "LoginViewController.h"
#import "FreeBoardListViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *tfLoginId;
@property (strong, nonatomic) IBOutlet UITextField *tfLoginPw;
@property (strong, nonatomic) IBOutlet UIButton *btLogin;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initView
{
    [self.tfLoginId setText:@"realksh"];
    [self.tfLoginPw setText:@"13524"];
    
    if ([self isSavedLoginId] && [self isSavedLoginPw]) {
        [self dismissViewControllerAnimated:YES completion:^{

        }];
        return;
    }
    if ([self isSavedLoginId]) {
        NSString* loginId = [[NSUserDefaults standardUserDefaults]stringForKey:LOGIN_ID];
        [self.tfLoginId setText:loginId];
    }
}

- (BOOL)isInputSuccess
{
    if (1 > self.tfLoginId.text.length) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"NMC"
                                                       message:@"empty id"
                                                      delegate:nil
                                             cancelButtonTitle:@"확인"
                                             otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    } else if (1 > self.tfLoginPw.text.length) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"NMC"
                                                       message:@"empty pw"
                                                      delegate:nil
                                             cancelButtonTitle:@"확인"
                                             otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

#pragma mark - Actions

- (IBAction)actionLogin:(id)sender
{
#if ENABLE_TEST

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

#else
    
//    if (![self isInputSuccess]) {
//        return;
//    }
    
    NSString* nm_id = self.tfLoginId.text;
    NSString* passwd = self.tfLoginPw.text;
    
    NSDictionary* param = @{IMAGE1_Y:@"2", IMAGE1_X:@"2", PASSWD:passwd, NM_ID:nm_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkAPI requestLogin:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        int state = [[dic objectForKey:STATE]intValue];
        
        if (state == RESPONSE_SUCCESS) {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(dismissLoginViewController)]) {
                    [self.delegate dismissLoginViewController];
                }
            }];
        } else if (state == RESPONSE_FAIL) {
            NSString* msg = [dic objectForKey:MESSAGE];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"NMC"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"확인"
                                                 otherButtonTitles: nil,
                                  nil];
            [alert show];
        }
    } failure:^(NSError* error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
#endif
}

#pragma mark - UITextField Delegate


@end
