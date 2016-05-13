//
//  FirCell.m
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ShowCell.h"

@implementation ShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickBtn:(UIButton *)sender {
    if (self.deleBlock) {
        self.deleBlock(sender.tag);
    }
}
@end
