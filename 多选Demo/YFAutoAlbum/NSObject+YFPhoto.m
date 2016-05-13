//
//  NSObject+YFPhoto.m
//  多选Demo
//
//  Created by 孙云 on 16/5/13.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "NSObject+YFPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+YF.h"

@implementation NSObject (YFPhoto)
/**
 *  打开相机
 */
- (void)showCamera{

    //选择相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    // picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    //进入照相界面
    [[self getCurrentVC] presentViewController:picker animated:YES completion:nil];
}
#pragma mark  相机代理
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    //图片
    UIImage *image;
    //判断是不是从相机过来的
    if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
        //关闭相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //通过判断picker的sourceType，如果是拍照则保存到相册去.非常重要的一步，不然，无法获取照相的图片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
/**
 *  确定相机图片保存到系统相册后，进行图片获取
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
    //操作获得的照片，我这是直接显示，你那个你加到你显示的一组里面去显示去就好了
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    //操作获得的照片，我这是直接显示，你那个你加到你显示的一组里面去显示去就好了
    [library afterCameraAsset:^(ALAsset *asset) {
        YFSelfImage *image = [[YFSelfImage alloc]initWithCGImage:asset.thumbnail];
        image.asset = asset;
        //传递
        NSDictionary *dic = @{@"saveImage":image};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SAVEIMAGE" object:nil userInfo:dic];
    }];
    
}
/**
 *  获取当前控制器
 *
 *  @return <#return value description#>
 */
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * nowW in windows)
        {
            if (nowW.windowLevel == UIWindowLevelNormal)
            {
                window = nowW;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
