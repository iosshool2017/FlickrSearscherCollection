//
//  Image.m
//  FlickrSearcher
//
//  Created by Admin on 22.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "Image.h"

@implementation Image

+ (Image *)imageFromResults: (NSDictionary*) dict{
    Image *image=[Image new];
    image.isloading=NO;
    NSString *name=dict[@"title"];
    image.name=name.length > 0 ? name : @"Untitled";
    image.url=[NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_s.jpg", dict[@"farm"], dict[@"server"], dict[@"id"],dict[@"secret"]];
    return image;
}

@end
