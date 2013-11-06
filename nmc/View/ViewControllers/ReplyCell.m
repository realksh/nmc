//
//  ReplyCell.m
//  nmc
//
//  Created by shkim on 2013. 11. 6..
//
//

#import "ReplyCell.h"

#define TAG_CELL_BODY_WEBVIEW   1000

@interface ReplyCell ()

@property (strong, nonatomic) UIWebView* webView;
@property (strong, nonatomic) IBOutlet UITextView *tvBody;

@end

@implementation ReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"Reply Cell initWithStyle!!");
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"Reply Cell Init!!");
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)setBody:(NSString *)body
{
    [self.tvBody setText:body];
    CGSize size = [self.tvBody sizeThatFits:CGSizeMake(self.tvBody.frame.size.width, 1000)];
    [self.tvBody setFrame:CGRectMake(self.tvBody.frame.origin.x, self.tvBody.frame.origin.y, self.tvBody.frame.size.width, size.height)];
    [self.vRoundBox setFrame:CGRectMake(self.vRoundBox.frame.origin.x, self.vRoundBox.frame.origin.y, self.vRoundBox.frame.size.width, size.height + 25)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.vRoundBox.frame.size.height + 10)];
}

@end
