//
//  FreeBoardDetailViewController.m
//  nmc
//
//  Created by shkim on 2013. 10. 29..
//
//

#import "FreeBoardDetailViewController.h"
#import "DetailInfoData.h"
#import "ReplyInfoData.h"
#import "ListInfoData.h"

@interface FreeBoardDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) DetailInfoData* detailInfo;

@end

@implementation FreeBoardDetailViewController

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
    [self requestDetailView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initView
{
    ListInfoData* info = (ListInfoData*)self.parameter;
    [self.navigationItem setTitle:info.title];
}

- (void)refreshScreen
{
    [self.webView loadHTMLString:self.detailInfo.body baseURL:nil];
}

- (void)requestDetailView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ListInfoData* info = (ListInfoData*)self.parameter;
    NSString* urlString = [NSString stringWithFormat:@"%@%@", URL_DETAIL, info.url];
    NSDictionary* dic = @{KEY_DETAIL_VIEW_URL:urlString};
    
    [NetworkAPI requestBoardDetail:dic type:BoardTypeGeneral success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        int state = [[dic objectForKey:KEY_STATE]intValue];
        
        if (state == RESPONSE_SUCCESS) {
            self.detailInfo = [dic objectForKey:KEY_DETAIL_INFO];
            [self refreshScreen];
        } else if (state == RESPONSE_FAIL) {
            NSString* msg = [dic objectForKey:KEY_MESSAGE];
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
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"NMC"
                                                       message:@"로그인에 실패하였습니다.\n잠시 후 다시 이용해주세요."
                                                      delegate:nil
                                             cancelButtonTitle:@"확인"
                                             otherButtonTitles: nil,
                              nil];
        [alert show];
    }];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* urlString = request.URL.absoluteString;
    
    if (UIWebViewNavigationTypeLinkClicked == navigationType) {
        if ([urlString hasPrefix:@"http://"]) {
            // push new webview with image & link
            
            return NO;
        }
    }
    
    return YES;
}

@end
