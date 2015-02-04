//
//  User.h
//  JsonMapObject
//
//  Created by Will on 4/2/2015.
//  Copyright (c) 2015年 Will. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TT.h"

@interface User : NSObject
/**
 *  名称
 */
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) TT *TT;

/**
 *  头像
 */
@property (strong, nonatomic) NSString *icon;
@end
