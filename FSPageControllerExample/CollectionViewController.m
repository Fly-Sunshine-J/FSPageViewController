//
//  CollectionViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/10.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewImageCell: UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CollectionViewImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _imageView.center = self.contentView.center;
        self.contentView.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end


@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CGFloat width = 0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight > screenWidth) {
        width = [UIScreen mainScreen].bounds.size.width / 4 - 3 * 0.1;
    }else {
        width = [UIScreen mainScreen].bounds.size.height / 4 - 3 * 0.1;
    }
    self.itemSize = CGSizeMake(width, width);
    [self collectionView];
    
//    模仿网络加载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            NSString *basePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"EmoticonQQ.bundle"];
            for (int i = 1; i < 142; i++) {
                NSString *imagePath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%03d", i]];
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
                [self.images addObject:image];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (NSMutableArray<UIImage *> *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0.1;
        layout.itemSize = self.itemSize;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CollectionViewImageCell class] forCellWithReuseIdentifier:@"CELL"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.imageView.image = self.images[indexPath.item];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
