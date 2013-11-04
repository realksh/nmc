//
//  BoardCell.m
//  nmc
//
//  Created by shkim on 13. 10. 24..
//
//

#import "BoardCell.h"

@implementation BoardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor* color = [UIColor blackColor];
    
    if (highlighted) {
        color = [UIColor whiteColor];
    }
    
    [self.labelTitle setTextColor:color];
    
    [super setHighlighted:highlighted animated:animated];
}

@end
