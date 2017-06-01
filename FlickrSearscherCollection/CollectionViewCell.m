//
//  CollectionViewCell.m
//  FlickrSearscherCollection
//
//  Created by Admin on 28.05.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(id) initWithFrame:(CGRect)frame
{
   self=[super initWithFrame:frame];
    if(self){
        _myImageView=[UIImageView new];
        //_myImageView.backgroundColor=[UIColor redColor];
        [_myImageView setFrame:CGRectMake(0, 0, 124,124)];//[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width)];
        [self.contentView addSubview:_myImageView];
    }
    return self;
}

- (void) configureCellContentSizeWidth:(float) width height:(float)height
{
    [_myImageView setFrame:CGRectMake(0, 0, width, height)];
}
-(void) startLoading
{
    _myImageView.backgroundColor=[UIColor greenColor];
}





@end
