//
//  BaseViewController.m
//  nmc
//
//  Created by shkim on 13. 10. 23..
//
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
	
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.view addGestureRecognizer:panRecognizer];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Public Methods

- (void)addRevealLeftNavigationBarItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
}

- (BOOL)isSavedLoginId
{
    NSString* loginId = [[NSUserDefaults standardUserDefaults]stringForKey:LOGIN_ID];
    
    if (!loginId) {
        return NO;
    }
    if (1 > loginId.length) {
        return NO;
    }
    return YES;
}

- (BOOL)isSavedLoginPw
{
    NSString* loginPw = [[NSUserDefaults standardUserDefaults]stringForKey:LOGIN_PASSWORD];
    
    if (!loginPw) {
        return NO;
    }
    if (1 > loginPw.length) {
        return NO;
    }
    return YES;
}

@end
