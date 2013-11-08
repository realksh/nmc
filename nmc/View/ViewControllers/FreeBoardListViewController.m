//
//  FreeBoardListViewController.m
//  nmc
//
//  Created by shkim on 13. 10. 22..
//
//

#import "FreeBoardListViewController.h"
#import "LoginViewController.h"
#import "FreeBoardDetailViewController.h"
#import "BoardCell.h"
#import "ListInfoData.h"
#import "UIAlertView+BlockExtensions.h"

@interface FreeBoardListViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrList;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation FreeBoardListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initProcess];
    [self addRevealLeftNavigationBarItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initProcess
{
    self.title = @"Free";
    
    self.arrList = [NSMutableArray array];
    [self addRefreshControl];
    
    if (![self isSavedLoginId] && ![self isSavedLoginPw]) {
        
        // id, pw 저장 되어 있지 않으면
        LoginViewController* vc = [[LoginViewController alloc]init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
        }];
        
        return;
    }
}

- (void)addRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc]initWithString:@"당겨서 새로 고침"]];
    [self.refreshControl setTintColor:[UIColor grayColor]];
    [self.tableView addSubview:self.refreshControl];
}

- (void)hideRefreshControl
{
    if (self.refreshControl.refreshing) {
        [self.refreshControl endRefreshing];
    }
}

- (void)requestListWithPage:(NSString*)page
{
    NSDictionary* dic = @{KEY_BOARD: @"popbbs3",
                          KEY_PAGE: page};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkAPI requestBoardList:dic type:BoardTypeGeneral success:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self hideRefreshControl];
        
        NSString* state = [dic objectForKey:KEY_STATE];
        
        if ([state isEqualToString:RESPONSE_SUCCESS]) {
            NSArray* array = [dic objectForKey:KEY_LIST];
            
            for (ListInfoData* info in array) {
                [self.arrList addObject:info];
            }
            
            [self.tableView reloadData];
        } else if ([state isEqualToString:RESPONSE_FAIL]) {
            NSString* msg = [dic objectForKey:KEY_MSG];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:kStrAlertTitle
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"확인"
                                                 otherButtonTitles: nil,
                                  nil];
            [alert show];
        } else if ([state isEqualToString:RESPONSE_NOT_LOGIN]) {
            NSString* msg = [dic objectForKey:KEY_MSG];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:kStrAlertTitle
                                                           message:msg
                                                   completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
                                                       LoginViewController* vc = [[LoginViewController alloc]init];
                                                       vc.delegate = self;
                                                       [self presentViewController:vc animated:YES completion:^{
                                                       }];
                                                   }
                                                 cancelButtonTitle:@"확인"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError* error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self hideRefreshControl];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:kStrAlertTitle
                                                       message:kStrAlertResponseFail
                                                      delegate:nil
                                             cancelButtonTitle:@"확인"
                                             otherButtonTitles: nil,
                              nil];
        [alert show];
    }];
}
#pragma mark - Actions

- (void)refreshTableView
{
    [self.arrList removeAllObjects];
    self.currentPage = 1;
    [self requestListWithPage:[NSString stringWithFormat:@"%d", self.currentPage]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BoardCell";
    
    BoardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
    }
    
    NSInteger row = indexPath.row;
    
    if (row >= self.arrList.count) {
        return cell;
    }
    
    ListInfoData* listData = [self.arrList objectAtIndex:row];
    
    NSString* title = listData.title;
    NSString* nickname = listData.nickname;
    NSString* replyCount = listData.numberOfReply;
    
    [cell.labelTitle setText:title];
    [cell.labelName setText:nickname];
    [cell.labelReplyCount setText:replyCount];
    
    if (row == self.arrList.count - 1) {
        self.currentPage++;
        [self requestListWithPage:[NSString stringWithFormat:@"%d", self.currentPage]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FreeBoardDetailViewController* vc = [[FreeBoardDetailViewController alloc]init];
    vc.parameter = [self.arrList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LoginView Delegate

- (void)dismissLoginViewController
{
    [self refreshTableView];
}

@end
