//
//  NSObject+YFPhoto.h
//  多选Demo
//
//  Created by 孙云 on 16/5/13.
//  Copyright © 2016年 haidai. All rights reserved.
/**
 *  相机照相处理，把公用类拿出来使用
 *
 *  @param YFPhoto <#YFPhoto description#>
 *
 *  @return <#return value description#>
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YFSelfImage.h"
@interface NSObject (YFPhoto)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (void)showCamera;
@end
