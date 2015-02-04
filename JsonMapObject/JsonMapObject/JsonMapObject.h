//
//  JsonMapObject.h
//  McAppIOS
//
//  Created by WillCheung on 14/8/22.
//  Copyright (c) 2014年 Will. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface JsonMapObject : NSObject

/**
 *  json 映射到对象
 *
 *  @param classname   类称
 *  @param dict        请求字典
 *  @param replaceDict 替代字典
 *
 *  @return 返回对象
 */
+ (id)JsonMapObjectWithClassName:(NSString *)classname requestNSDictionay:(NSDictionary *)dict replaceNSDictionary:(NSDictionary*)replaceDict;

@end
