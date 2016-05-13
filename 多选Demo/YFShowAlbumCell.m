//
//  ShowCell.m
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "YFShowAlbumCell.h"

@implementation YFShowAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 *  按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickBtn:(UIButton *)sender {
    
    if(!sender.selected){
    
        if (self.selectedBlock) {
            self.selectedBlock(sender.tag);
        }
        //做个小动画
        CABasicAnimation *anima = [CABasicAnimation animation];
        anima.keyPath = @"transform.scale";
        anima.toValue = @(1.3);
        anima.duration = 0.3;
        [sender.layer addAnimation:anima forKey:nil];
    }else{
    
        if (self.cancelBlock) {
            self.cancelBlock(sender.tag);
        }
    }
    
    sender.selected = !sender.selected;
}
@end
