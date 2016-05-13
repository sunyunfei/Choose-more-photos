//
//  FirViewController.m
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ShowViewController.h"
#import "NSObject+YFPhoto.h"
#import "YFShowGroupAlbumVC.h"
#import "ShowCell.h"
#import "YFSelfImage.h"
#import "ALAssetsLibrary+YF.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define K_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_HEIGHT [UIScreen mainScreen].bounds.size.height
static NSString * const FIRCELL = @"ShowCell";
@interface ShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{

    NSMutableArray *imageArray; //数组
    YFShowGroupAlbumVC *showVC; //显示相册分组的控制器
    UINavigationController *navShow; //因为相册分组是模态出来的，所以给他一个导航，让相册详细界面可以导航出来
}
@property(nonatomic,strong)showBigImage *showView;//大图
//左边按钮
- (IBAction)clickLeftBtn:(id)sender;
//右边按钮
- (IBAction)clickBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray = [NSMutableArray array];
    showVC = [[YFShowGroupAlbumVC alloc]init];
    navShow = [[UINavigationController alloc]initWithRootViewController:showVC];

    [_collectionView registerNib:[UINib nibWithNibName:FIRCELL bundle:nil] forCellWithReuseIdentifier:FIRCELL];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self setCollectionLayOut];
    //接受通知 一个是把宰相册详情选择的图片传过来，一个是把相机照的图片传过来
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notShow:) name:@"pushImage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveImageSure:) name:@"SAVEIMAGE" object:nil];
}
/**
 *  获得选中的图片数组
 *
 *  @param user <#user description#>
 */
- (void)notShow:(NSNotification *)user{

    [imageArray removeAllObjects];
    NSDictionary *dic = user.userInfo;
    [imageArray addObjectsFromArray:dic[@"cellImage"]];
    [_collectionView reloadData];
}
/**
 *  获得相机图片
 *
 *  @param user <#user description#>
 */
- (void)saveImageSure:(NSNotification *)user{

    NSDictionary *dic = user.userInfo;
    YFSelfImage *image = dic[@"saveImage"];
    [imageArray addObject:image];
    [_collectionView reloadData];
}
/**
 *  设置布局
 */
- (void)setCollectionLayOut{

    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(K_WIDTH / 3, K_WIDTH / 3);
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing= 0;
    [_collectionView setCollectionViewLayout:layOut];
}
/**
 *  左边按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickLeftBtn:(id)sender {

    //弹出选择视图
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"相 机" otherButtonTitles:@"相 册", nil];
    [sheet showInView:self.view];

}
/**
 *  右边按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickBtn:(id)sender {
    showVC.showAlbumStyle = ENUM_PhotoAndCamera;
    showVC.albumColor = [UIColor whiteColor];
    showVC.listCount = 4;
    [self presentViewController:navShow animated:YES completion:nil];
}
#pragma mark  actionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
            //打开相机
            [self showCamera];
            break;
        case 1:
            //打开相册
            showVC.showAlbumStyle = ENUM_AllOfPhoto;
            showVC.albumColor = [UIColor whiteColor];
            showVC.listCount = 5;
            [self presentViewController:navShow animated:YES completion:nil];
            break;
        case 2:
            NSLog(@"2");
            break;
        default:
            break;
    }
}

#pragma mark   九宫格代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FIRCELL forIndexPath:indexPath];
    cell.deleBtn.tag = indexPath.row;
    //删除
    __weak typeof(self)weakSelf = self;
    cell.deleBlock = ^(NSInteger index){
    
       //删除数组中对应的元素
        [imageArray removeObjectAtIndex:index];
        [weakSelf.collectionView reloadData];
    };
    YFSelfImage *image = imageArray[indexPath.row];
    cell.imageView.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    YFSelfImage *image = imageArray[indexPath.row];
    //获取图片的详细资源
    ALAssetRepresentation *represention = [image.asset defaultRepresentation];
    //获取高清图
    UIImage *bigImage = [[UIImage alloc]initWithCGImage:[represention fullResolutionImage]];
    //显示大图
    if (!_showView) {
        _showView = [[showBigImage alloc]initWithFrame:CGRectMake(0, 64, K_WIDTH, K_HEIGHT - 64)];
        _showView.bigImageView.image = bigImage;
        _showView.alpha = 1.0;
        __weak typeof(self)weakSelf = self;
        _showView.hiddenBlock = ^{
        
            weakSelf.showView.alpha = 0.0;
        };
        [self.view addSubview:_showView];
    }else{
    
        _showView.bigImageView.image = bigImage;
        _showView.alpha = 1.0;
    }
}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

/***************************大图显示view******************************/
@implementation showBigImage

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        _bigImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_bigImageView];
        _bigImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
        [self.bigImageView addGestureRecognizer:tap];
    }
    return self;
}
- (void)hiddenView{

    if (self.hiddenBlock) {
        self.hiddenBlock();
    }
}
@end