//
//  StatusResult.h
//  JsonMapObject
//
//  Created by Will on 4/2/2015.
//  Copyright (c) 2015年 Will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusResult : NSObject
/**
 *  存放着某一页微博数据（里面都是Status模型）
 */
@property (strong, nonatomic) NSMutableArray *statuses;

/**
 *  存放着一堆的广告数据（里面都是Ad模型）
 */
@property (strong, nonatomic) NSArray *ads;

/**
 *  总数
 */
@property (strong, nonatomic) NSNumber *totalNumber;

/**
 *  上一页的游标
 */
@property (strong, nonatomic) NSNumber *previousCursor;

/**
 *  下一页的游标
 */
@property (strong, nonatomic) NSNumber *nextCursor;
@end
