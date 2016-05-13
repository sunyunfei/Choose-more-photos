//
//  ShowViewController.h
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
/**
 *  显示详细相册
 */

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef enum{//如果不自主选择显示形式，默认全图片显示

    ENUM_Photo,//只显示图片
    ENUM_Camera//显示图片和相机
}ENUM_showLayoutStyle;
@interface YFShowAlbumVC : UIViewController
//获得相册组
@property(nonatomic,strong)ALAssetsGroup *group;
//相册的背景色(默认黑色)
@property(nonatomic,strong)UIColor *color;
//一行能显示几张图片,默认四个
@property(nonatomic,assign)NSInteger listCount;
//显示的形式
@property(nonatomic,assign)NSInteger showStyle;
@end
