//
//  Image.h
//  FlickrSearcher
//
//  Created by Admin on 22.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UiKit.h"

@interface Image : NSObject

@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSString *url;
@property (nonatomic,strong) NSString *name;
@property(nonatomic) BOOL isloading;

+ (Image * )imageFromResults: (NSDictionary*) dict;

@end
