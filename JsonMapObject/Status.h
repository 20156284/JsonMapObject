//
//  Status.h
//  JsonMapObject
//
//  Created by Will on 4/2/2015.
//  Copyright (c) 2015年 Will. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Status : NSObject
/**
 *  微博文本内容
 */
@property (strong, nonatomic) NSString *text;

/**
 *  微博作者
 */
@property (strong, nonatomic) User *user;



@end
