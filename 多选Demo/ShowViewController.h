//
//  FirViewController.h
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewController : UIViewController

@end

@interface showBigImage : UIView
@property(nonatomic,strong)UIImageView *bigImageView;
@property(nonatomic,copy)void(^hiddenBlock)();
@end