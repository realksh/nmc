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

@interface FreeBoardDetailViewController () <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DetailInfoData* detailInfo;
@property (strong, nonatomic) IBOutlet UILabel *lbNickname;
@property (strong, nonatomic) IBOutlet UIImageView *ivNickName;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *vTopInfo;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbHits;

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
    [self initProcess];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initProcess
{
    [self.navigationItem setTitle:@"나매 일반 게시판"];
 
    ListInfoData* info = (ListInfoData*)self.parameter;
    
    [self.lbTitle setText:info.title];
    [self.lbNickname setText:info.nickname];
    [self.lbDate setText:info.date];
    [self.lbHits setText:[NSString stringWithFormat:@"조회 %@", info.hitsCount]];
    
    self.webView.scrollView.delegate = self;
//    [self.webView.scrollView setScrollEnabled:NO];
    [self requestDetailView];
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
        
        NSString* state = [dic objectForKey:KEY_STATE];
        
        if ([state isEqualToString:RESPONSE_SUCCESS]) {
            self.detailInfo = [dic objectForKey:KEY_DETAIL_INFO];
            [self refreshScreen];
        } else if ([state isEqualToString:RESPONSE_FAIL]) {
            NSString* msg = [dic objectForKey:KEY_MSG];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:kStrAlertTitle
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"확인"
                                                 otherButtonTitles: nil,
                                  nil];
            [alert show];
        }
    } failure:^(NSError* error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:kStrAlertTitle
                                                       message:kStrAlertResponseFail
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

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (self.vTopInfo.frame.size.height < offsetY) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.vTopInfo setFrame:CGRectMake(self.vTopInfo.frame.origin.x, -(self.vTopInfo.frame.size.height), self.vTopInfo.frame.size.width, self.vTopInfo.frame.size.height)];
            [self.webView setFrame:CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y - self.vTopInfo.frame.size.height, self.webView.frame.size.width, self.webView.frame.size.height + self.vTopInfo.frame.size.height)];
        }];
    }
}

@end
