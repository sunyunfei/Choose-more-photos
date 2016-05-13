//
//  ShowCell.h
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFShowAlbumCell : UICollectionViewCell
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//按钮选定
@property(nonatomic,copy)void(^selectedBlock)(NSInteger index);
//取消选定
@property(nonatomic,copy)void(^cancelBlock)(NSInteger index);
//按钮事件
- (IBAction)clickBtn:(UIButton *)sender;

@end
