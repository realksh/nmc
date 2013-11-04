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

@interface FreeBoardListViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrList;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addRevealLeftNavigationBarItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initView
{
    self.title = @"Free";
    
    if (![self isSavedLoginId] && ![self isSavedLoginPw]) {
        LoginViewController* vc = [[LoginViewController alloc]init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
        }];
    } else {
        
    }
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
    
    ListInfoData* listData = [self.arrList objectAtIndex:row];
    
    NSString* title = listData.title;
    
    [cell.labelTitle setText:title];
    
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
    NSDictionary* dic = @{BOARD: @"popbbs3"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkAPI requestBoardList:dic type:BoardTypeGeneral success:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
        int state = [[dic objectForKey:STATE]intValue];
        
        if (state == RESPONSE_SUCCESS) {
            self.arrList = [dic objectForKey:LIST];
            [self.tableView reloadData];
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
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"NMC"
                                                       message:@"로그인에 실패하였습니다.\n잠시 후 다시 이용해주세요."
                                                      delegate:nil
                                             cancelButtonTitle:@"확인"
                                             otherButtonTitles: nil,
                              nil];
        [alert show];
    }];
}

@end
