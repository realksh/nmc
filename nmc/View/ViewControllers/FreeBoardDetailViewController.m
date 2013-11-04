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

@interface FreeBoardDetailViewController ()

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
    
}

- (void)requestDetailView
{
    ListInfoData* info = (ListInfoData*)self.parameter;
    NSString* urlString = info.url;
    NSDictionary* dic = @{URL_DETAIL:urlString};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkAPI requestBoardDetail:dic type:BoardTypeGeneral success:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        int state = [[dic objectForKey:STATE]intValue];
        
        if (state == RESPONSE_SUCCESS) {
            DetailInfoData* info = [dic objectForKey:DETAIL_INFO];
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
