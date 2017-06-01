//
//  SearchResultModel.h
//  FlickrSearcher
//
//  Created by Admin on 22.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject

@property (copy,nonatomic) NSArray *images;
@property (nonatomic,strong) NSString *FlickrAPIKey;

- (void)getImages:(NSString *)request withCompletionHandler: (void (^)(void))completionHandler;
- (void)downloadImage:(NSIndexPath *)itemIndexPath withCompletionHandler:(void (^)(NSIndexPath *indexpath))completionHandler;

@end
