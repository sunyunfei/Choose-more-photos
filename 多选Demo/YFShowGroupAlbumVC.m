//
//  ViewController.m
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "YFShowGroupAlbumVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YFShowAlbumVC.h"
#import "ALAssetsLibrary+YF.h"
@interface YFShowGroupAlbumVC ()<UITableViewDelegate,UITableViewDataSource>
{

    ALAssetsLibrary *library;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation YFShowGroupAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相 册";
    //左侧返回按钮
    [self leftItemBtn];
    _dataArray = [NSMutableArray array];
    [self initTableView];
    //获得相册个数
    __weak typeof(self)weakSelf = self;
    library = [[ALAssetsLibrary alloc]init];
    [library countOfAlbumGroup:^(ALAssetsGroup *yfGroup) {
        [weakSelf.dataArray addObject:yfGroup];
        [_tableView reloadData];
    }];
}
#pragma mark 返回按钮设置事件
/**
 *  设置左边返回按钮
 */
- (void)leftItemBtn{

    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [returnBtn setTitle:@"取 消" forState:UIControlStateNormal];
    returnBtn.frame = CGRectMake(0, 0, 40, 30);
    [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc]initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = itemBtn;
}
//返回按钮
- (void)clickReturnBtn{

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  加载表
- (void)initTableView{

    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}
#pragma mark 表的代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * const ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ALAssetsGroup *group = (ALAssetsGroup *)[_dataArray objectAtIndex:indexPath.row];
    if (group) {
        //相册第一张图片
        cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
        //相册名字
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        if ([groupName isEqualToString:@"Camera Roll"]) {
            groupName = @"我的相册";
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",groupName,(long)[group numberOfAssets]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转
    YFShowAlbumVC *show = [[YFShowAlbumVC alloc]init];
    ALAssetsGroup *group = (ALAssetsGroup *)[_dataArray objectAtIndex:indexPath.row];
    show.group = group;
    show.listCount = self.listCount;
    show.color = self.albumColor;
    show.showStyle = self.showAlbumStyle;
    [self.navigationController pushViewController:show animated:YES];
}
@end
