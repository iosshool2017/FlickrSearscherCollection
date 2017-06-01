//
//  ViewController.m
//  FlickrSearscherCollection
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "CollectionViewController.h"
#import "SearchResultModel.h"
#import "CollectionViewCell.h"
#import "Image.h"

@interface CollectionViewController () <UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *settingButton;
@property(strong,nonatomic) SearchResultModel *model;
@property (nonatomic,strong) NSOperationQueue * queue;
@property (nonatomic) NSInteger loadIndex;

@end

@implementation CollectionViewController

-(instancetype) init{
    self=[super init];
    if (self)
    {
        UIImage *imageFeed=[UIImage imageNamed:@"icFeed"];
        self.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"Лента" image:imageFeed tag:0];
        //UIImage *imageLikes=[UIImage imageNamed:@"icLikes"];
        //self.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"Избранное" image:imageLikes tag:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *myGrayColor=[UIColor colorWithRed:250 green:250 blue:250 alpha:0.9];
    self.view.backgroundColor=myGrayColor;
    UIView *navigationView=[[UIView alloc] initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width,64)];
    self.searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(8,26,317,29)];
    //self.searchBar.barStyle = UISearchBarStyleProminent;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"rectangle121"];
    self.searchBar.placeholder=@"Поиск";
    self.searchBar.delegate=self;
    //[self.searchBar becomeFirstResponder];
    //_searchBar.barTintColor =myGrayColor;
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"rectangle121"] forState:UIControlStateNormal];
    self.settingButton=[[UIButton alloc] initWithFrame:CGRectMake(337,28,24,24)];
    UIImage *settingsImage = [UIImage imageNamed:@"icSettings"];
    [self.settingButton setImage:settingsImage forState:UIControlStateNormal];
    [navigationView addSubview:self.searchBar];
    [navigationView addSubview:self.settingButton];
    [self.view addSubview:navigationView];
     UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width,self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor=myGrayColor;
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    self.model=[SearchResultModel new];
    self.queue = [[NSOperationQueue alloc] init];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    _loadIndex=0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Search Bar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *request=searchBar.text;
    [searchBar endEditing:YES];
    _loadIndex=0;
    NSLog(@"new search @%@",request);
    if (request)
    {
        __weak typeof (self) weakself=self;
        [self.model getImages:request  withCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
               [weakself.collectionView reloadData];
            });
        }];
        
        
    }
    
}
/*- (void)arrangeCollectionView {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    } else {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    */
   /* self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self arrangeCollectionView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self arrangeCollectionView];
}

*/
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.model.images.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    Image *image=self.model.images[indexPath.row];
    if ((!image.image)&&(!image.isloading)) {
        NSLog(@"start load img ip=%ld isl=%d",indexPath.row,image.isloading);
        image.isloading=YES;
        [cell startLoading];
        NSOperation *loadImgOp = [[NSInvocationOperation alloc]
                                  initWithTarget:self
                                  selector:@selector(loadImageInBackground:)
                                  object:indexPath];
        [self.queue addOperation:loadImgOp];
        
        //    cell.imageView.image = [UIImage imageNamed:@"image"];
        //    __weak typeof(self) weakself=self;
        //    [self.model downloadImage:indexPath withCompletionHandler:^(NSIndexPath *indexpath) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            TableViewCell * cell=[weakself.tableView cellForRowAtIndexPath:indexpath];
        //            cell.myImageView.image = [self convertImageToGrayScale:image.image];
        //            NSLog(@"load img");
        //        });
        //    }];
    }
    else
    {
        cell.myImageView.image = image.image;
    }
    return cell;
    
}
-(void)loadImageInBackground:(NSIndexPath *)itemIndexPath {
    Image *currentItem = _model.images[itemIndexPath.row];
    ////
    __weak typeof(self) weakself=self;
    [self.model downloadImage:itemIndexPath  withCompletionHandler:^(NSIndexPath *itemIndexPath ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CollectionViewCell *cell=[weakself.collectionView cellForItemAtIndexPath:itemIndexPath ];            //currentItem.image=[self convertImageToGrayScale:currentItem.image];
            cell.myImageView.image =currentItem.image;
            NSLog(@"load img %ld ip=%ld",_loadIndex,itemIndexPath.row);
            _loadIndex++;
        });
    }];
    //////
    
    //    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentItem.url]];
    //    UIImage *downloadedImage = [UIImage imageWithData:imageData];
    //    downloadedImage=[self convertImageToGrayScale:downloadedImage];
    //    __weak typeof(self) weakself=self;
    //    TableViewCell * cell=[weakself.tableView cellForRowAtIndexPath:itemIndexPath];
    // [cell.myImageView.image performSelectorOnMainThread:@selector(setImage:)
    //                                  withObject:downloadedImage
    //                             waitUntilDone:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [[UICollectionReusableView alloc] init];
    
}

#pragma mark – UICollectionViewDelegateFlowLayout
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(370, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"detail" sender:self];
}
*/
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // CGFloat picDimension = self.view.frame.size.width / 4.0f;
    return CGSizeMake(124,124);//picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
    return UIEdgeInsetsMake(0, 0,0,0);//leftRightInset, 0, leftRightInset);
}


@end
