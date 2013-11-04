//
//  RearMenuViewController.m
//  nmc
//
//  Created by shkim on 13. 10. 24..
//
//

#import "RearMenuViewController.h"
#import "RearMenuCell.h"
#import "RevealController.h"

#import "FreeBoardListViewController.h"

@interface RearMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* arList;

@end

@implementation RearMenuViewController

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
#warning 메뉴 리스트는 plist 로 구성
    // section 1
    NSArray* arSection0 = @[@"free"];
    self.arList = @[arSection0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.arList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RearMenuCell";
    RearMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
    }
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    cell.lbTitle.text = [[self.arList objectAtIndex:section]objectAtIndex:row];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
     
     RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
     
     if (indexPath.section == 0) {
         if (indexPath.row == 0)
         {
             // Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
             if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[FreeBoardListViewController class]])
             {
                 FreeBoardListViewController *frontViewController = [[FreeBoardListViewController alloc] init];
                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                 [revealController setFrontViewController:navigationController animated:NO];
             }
             // Seems the user attempts to 'switch' to exactly the same controller he came from!
             else
             {
                 [revealController revealToggle:self];
             }
         }
     }
 }

@end
