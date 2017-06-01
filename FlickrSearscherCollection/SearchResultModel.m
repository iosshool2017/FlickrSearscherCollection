//
//  SearchResultModel.m
//  FlickrSearcher
//
//  Created by Admin on 22.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "SearchResultModel.h"
#import "Image.h"

@implementation SearchResultModel

-(instancetype) init{
    self=[super init];
    _FlickrAPIKey=@"8385790adee27e2c22b8ffb95eacb9ad";
    //8385790adee27e2c22b8ffb95eacb9ad
    //Secret:
    //d138ee6764e7ffaa
    return self;
}

-(void) getImages:(NSString*) searchStr withCompletionHandler: (void (^)(void))completionHandler {
    
    NSString *searchStrWithoutSpace=[searchStr stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *searchStrUrl = [searchStrWithoutSpace stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
   //ps://api.flickr.com/services/rest/?method=flickr.photos.search&text=Cat&api_key=c55f5a419863413f77af53764f86bd66&format=json&nojsoncallback=1
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1", _FlickrAPIKey, searchStrUrl]];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.images=[self parseData:data];
        completionHandler();
        if(error){
            NSLog(@"Error download data %@",error.userInfo);
        }
    }];
    [task resume];
}

- (NSArray *)parseData:(NSData *)data {
    if (!data)
    {
        return nil;
    }
    NSError *error=nil;
    NSDictionary* json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error){
        NSLog(@"Error parse%@",error.userInfo);
    }
    NSMutableArray *images =[NSMutableArray new];
    for (NSDictionary * results in [[json objectForKey:@"photos"] objectForKey:@"photo"]) {
        [images addObject:[Image imageFromResults:results]];
    }
    return [images copy];
}

- (void)downloadImage:(NSIndexPath *)itemIndexPath withCompletionHandler:(void (^)(NSIndexPath *indexpath))completionHandler{
    Image *currentItem = self.images[itemIndexPath.row];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url=[NSURL URLWithString:currentItem.url];
    NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        currentItem.image=[UIImage imageWithData:data];
        completionHandler(itemIndexPath);
        if(error){
            NSLog(@"Error download data %@",error.userInfo);
        }
    }];
    [task resume];
}
@end
