//
//  ReplyCell.h
//  nmc
//
//  Created by shkim on 2013. 11. 6..
//
//

#import <UIKit/UIKit.h>

#define REPLY_CELL_BODY_WIDTH           260
#define REPLY_CELL_BODY_DEFAULT_HEIGHT  33

@interface ReplyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbNickname;
@property (strong, nonatomic) IBOutlet UIView *vRoundBox;

- (void)setBody:(NSString*)body;

@end
