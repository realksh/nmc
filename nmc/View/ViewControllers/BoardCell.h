//
//  BoardCell.h
//  nmc
//
//  Created by shkim on 13. 10. 24..
//
//

#import <UIKit/UIKit.h>

@interface BoardCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelReplyCount;

@end
