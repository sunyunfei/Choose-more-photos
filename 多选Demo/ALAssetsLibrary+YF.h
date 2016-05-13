//
//  ALAssetsLibrary+YF.h
//  多选Demo
//
//  Created by 孙云 on 16/5/13.
//  Copyright © 2016年 haidai. All rights reserved.
/**
 *  拿出公共使用的方法
 *
 *  @param YF <#YF description#>
 *
 *  @return <#return value description#>
 */

#import <AssetsLibrary/AssetsLibrary.h>
#import "YFSelfImage.h"
@interface ALAssetsLibrary (YF)
//获得照相后的图片
- (void)afterCameraAsset:(void(^)(ALAsset *asset))block;
- (void)countOfAlbumGroup:(void(^)(ALAssetsGroup *yfGroup))block;
- (void)callAllPhoto:(ALAssetsGroup *)group result:(void(^)(YFSelfImage *image))block;
@end
