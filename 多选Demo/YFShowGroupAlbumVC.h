//
//  ViewController.h
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
/**
 *   显示相册组
 */

#import <UIKit/UIKit.h>
typedef enum{//如果不自主选择显示形式，默认全图片显示
    
    ENUM_AllOfPhoto,//只显示图片
    ENUM_PhotoAndCamera//显示图片和相机
}ENUM_ShowAlbumStyle;
@interface YFShowGroupAlbumVC : UIViewController
//显示照片的模式
@property(nonatomic,assign)NSInteger showAlbumStyle;
//显示照片的背景色
@property(nonatomic,strong)UIColor *albumColor;
//显示照片的一行几个
@property(nonatomic,assign)NSInteger listCount;
@end

