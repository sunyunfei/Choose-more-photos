//
//  FirCell.h
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)clickBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property(nonatomic,copy)void(^deleBlock)(NSInteger index);
@end
