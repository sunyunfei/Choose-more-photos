//
//  ALAssetsLibrary+YF.m
//  多选Demo
//
//  Created by 孙云 on 16/5/13.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ALAssetsLibrary+YF.h"

@implementation ALAssetsLibrary (YF)
/**
 *  获得照相的图片
 *
 */
- (void)afterCameraAsset:(void(^)(ALAsset *asset))block{
    
    [self enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse/*遍历方式*/ usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    if (block) {
                        block(result);
                    }
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    } failureBlock:^(NSError *error) {
        if (error) {
            NSLog(@"相机图片错误，%@",error);
        }
    }];
}

- (void)countOfAlbumGroup:(void(^)(ALAssetsGroup *yfGroup))block{
    
    //计算有几个相册
    [self enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (block) {
                block(group);
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"获取相册错误,%@",error);
    }];
    
}
/**
 *  获得一个相册有多少照片
 *
 */
- (void)callAllPhoto:(ALAssetsGroup *)group result:(void(^)(YFSelfImage *image))block{
    
    //获得所有的图片资源
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            YFSelfImage *image = [[YFSelfImage alloc]initWithCGImage:[result thumbnail]];
            image.asset = result;
            block(image);
        }
    }];
}
@end
