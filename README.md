# 前言
经过几天的断断续续的编写终于把这一个小项目完成了，现在刚刚完成，代码看着不整洁，请多包涵。
前几天要弄个相册多选和照相选图的功能，以前做过单选上传头像之类的。但是多选确实不像那么简单，github找了好多的例子，都是在用几个框架。不是说人家封的不好，封的很好，但是卤煮比较笨，看了好久还是马马虎虎。然后上网查了下资料，还是决定自己写一个。


# 正文
多选主要是需要一个frameworks：AssetsLibrary。这个类的主要功能就是多选（个人理解，不对请见谅）。
首先，我们从相册开始：
要查看所有的相册，简单的思路大家应该都有：获取相册组－－－获取相册，但是怎么进行呢，AssetsLibrary的用处来了。
```
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

```
这个是计算相册数，可能手机相册会有好几个，所以要查看一下有几个，毕竟用户有很大的可能只会选择某一个相册里面的某一张相片。我是把这个方法拿了出来专门创建了一个类，这样代码思路会清晰一些。
既然我们知道有几个相册了，每个相册的一些信息也知道了，那么我们应该去显示某一个相册里面的所有照片了呀。这一步的代码来了：
```
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
```
这个方法的一个参数group，就是上一个代码段得到的相册group，拿到group之后就去求里面所有的照片。这里涉及到两个点我说一下：
### YFSelfImage
这是一个我自己稍微封装了uiimage的一个类
```
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
```
比普通的UIImage多了一个属性，asset。这一个就是要说的第二个点。
### ALAsset
这一个类应该是多选里面最关联的一个类了，它有照片的信息关联，比如缩略图之类的都可以通过它获取。所以，我们多选全靠它去做事情。（关于用法和属性，请google吧，网上有很多很多）。
好了，现在相册里面的照片也获取了，我要把它都显示出来了，哎呀呀呀呀，龟派气功波～～～～～～
```
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    YFShowAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SHOWCELL forIndexPath:indexPath];

        YFSelfImage *image = [_dataArray objectAtIndex:indexPath.row];
        cell.imageView.image = image;

    return cell;
}
```
然后我们可以查看效果了：
相册组：
![相册组](http://img.blog.csdn.net/20160513181050208)
相册：
![相册](http://img.blog.csdn.net/20160513181123703)
好了，基本的显示完成了，大家也看到了，我上面有个完成按钮。那么我们是不是需要在照片那来个选择按钮，然后我们得到选择的图片是吧，不然只是实现查看相册有什么卵用。
再次编辑collectionview：
```
 YFShowAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SHOWCELL forIndexPath:indexPath];
 cell.selectBtn.tag = cellIndex;
    //按钮选中块
    __weak typeof(self)weakSelf = self;
    cell.selectedBlock = ^(NSInteger index){
    
        //把选中的图片放倒一个数组里面
        [weakSelf.selectedArray addObject:[weakSelf.dataArray objectAtIndex:index]];
        selectBtn.userInteractionEnabled = YES;
    };
    //取消选定
    cell.cancelBlock = ^(NSInteger index){
    
        //找出取消的cell
        YFSelfImage *oldImage = [weakSelf.dataArray objectAtIndex:index];
        //从选中的数组去除
        for (YFSelfImage *newImage in weakSelf.selectedArray) {
            if (newImage == oldImage) {
                //移除
                [weakSelf.selectedArray removeObject:newImage];
                //判断完成按钮是否可以使用
                if(weakSelf.selectedArray.count <= 0){
                    
                    selectBtn.userInteractionEnabled = NO;
                }
                return ;
            }
        }
    };
YFSelfImage *image = [_dataArray objectAtIndex:cellIndex];
        cell.imageView.image = image;
        return cell;
}
```
再来看一下效果：
![这里写图片描述](http://img.blog.csdn.net/20160513181545351)
好了，现在我们是可以选择了，现在我们要实现的是把我们选择的照片拿到放到一个数组里面保存使用。前段代码大家应该看见了，照片按钮的选中与取选操作都谢了，我们现在完成“完成”这个按钮操作了：
```
/**
 *  完成选定
 */
- (void)successChoose{

    //把选择的图片传送过去
    NSDictionary *dic = @{@"cellImage":self.selectedArray};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushImage" object:nil userInfo:dic];
    //退出模态
    [self dismissViewControllerAnimated:YES completion:^{
        //这一步确保退出到显示界面的时候显示相册组控制器一定退出
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
```
这个有个解释点：
就是数退出模态后又做了一次导航pop。因为这个项目的界面布局是：
![这里写图片描述](http://img.blog.csdn.net/20160513182440339)
所以，我从单相册显示界面dismiss相当于直接回到开始界面，但是你在下一次在进入相册组界面的时候会出问题，它会直接进入单相册显示界面，也就是说在你dismiss之后后者两个界面貌似没有释放的样子，还是记住了相册组界面push到单相册界面的状态。所以我在此处做了一个pop，防止出现这个问题。
在完成按钮时，我已经选择了通过通知把数组带回了开始界面。所以开始界面会有我们所选择的照片的显示。
![这里写图片描述](http://img.blog.csdn.net/20160513182840590)
这里说一下，这个删除事件我就不讲了，大家一看应该都懂的。略过～～～～～～
好了，现在开始相机选择照片这一块：
首先我们打开一下相册，固定死代码：
```
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
```
然后嘞，嘎嘎，照了照片之后，我们选择这张照片，那么学问来了，我们选择这张照片可以直接去 
```
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{｝
```
这个代理里面去做操作，当然为了和相册多选照片的属性一致，我们需要做点操作。首先思路应该是把照的照片先放到相册，然后我们去相册去拿到这个相册最后一张图片，就是这个相机照的图片。
多说无益，上代码：
```
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

```
好了，现在我们获到了相机图片。
然后我还是选择发送一个通知把照片传给显示页。
# 结语
好了，好了，不行了，不写了。应该也差不多了。还有一些小的功能没有写，一切都在代码里面。
