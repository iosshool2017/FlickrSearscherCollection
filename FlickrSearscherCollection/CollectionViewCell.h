//
//  CollectionViewCell.h
//  FlickrSearscherCollection
//
//  Created by Admin on 28.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) UIImageView *myImageView;

- (void) configureCellContentSizeWidth:(float) width height:(float)height;
- (void) startLoading;


@end
