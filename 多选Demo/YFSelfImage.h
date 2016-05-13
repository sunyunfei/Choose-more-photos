//
//  MyImage.h
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
/**
 *  用于储存相册图片，附有一个asset信息，用于图片的其他处理
 *
 */
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface YFSelfImage : UIImage
//可能需要的图片信息
@property(nonatomic,strong)ALAsset *asset;
@end
