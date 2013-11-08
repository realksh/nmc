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
#import "ReplyCell.h"

#define TAG_DETAIL_BODY_WEBVIEW     1000

@interface FreeBoardDetailViewController () <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lbNickname;
@property (strong, nonatomic) IBOutlet UIImageView *ivNickName;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *vTopInfo;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbHits;
@property (strong, nonatomic) DetailInfoData* detailInfo;

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
    [self.webView.scrollView setScrollEnabled:NO];
    self.webView.tag = TAG_DETAIL_BODY_WEBVIEW;
    [self requestDetailView];
}

- (void)refreshScreen
{
    NSString* body = [NSString stringWithFormat:@"%@", self.detailInfo.body];
    [self.tableView reloadData];
    [self.webView loadHTMLString:body baseURL:nil];
}

- (void)reframeScreen
{
    [self.tableView setFrame:CGRectMake(0,
                                        self.webView.frame.origin.y + self.webView.frame.size.height + 20,
                                        self.tableView.frame.size.width,
                                        self.tableView.contentSize.height)];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.tableView.frame.origin.y + self.tableView.frame.size.height)];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    [webView setFrame:frame];
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, fittingSize.height);
    
    [webView setFrame:frame];
    
    if (TAG_DETAIL_BODY_WEBVIEW == webView.tag) {
        [self reframeScreen];
    }
    
//    NSLog(@"frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.detailInfo) {
        return 0;
    }
    
    NSInteger count = self.detailInfo.replyList.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReplyCell";
    
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        [cell.vRoundBox.layer setCornerRadius:10];
    }

    NSInteger row = indexPath.row;
    
    if (row >= self.detailInfo.replyList.count) {
        return cell;
    }
    
    ReplyInfoData* replyInfo = [self.detailInfo.replyList objectAtIndex:row];

    NSString* body = replyInfo.body;
    NSString* nickname = replyInfo.nickname;
    
    [cell setBody:body];
    [cell.lbNickname setText:nickname];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailInfo) {
        return 0;
    }
    
    ReplyInfoData* info = [self.detailInfo.replyList objectAtIndex:indexPath.row];
    
    UITextView* tv = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, REPLY_CELL_BODY_WIDTH, 1000)];
    [tv setFont:[UIFont systemFontOfSize:13]];
    NSString* body = [NSString stringWithFormat:@"%@  ", info.body];
    [tv setText:body];
    CGSize size = [tv sizeThatFits:CGSizeMake(REPLY_CELL_BODY_WIDTH, 0)];
    CGFloat height = 31 + size.height;

    return height;
}

@end
