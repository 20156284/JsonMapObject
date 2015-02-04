//
//  Tx.h
//  JsonMapObject
//
//  Created by Will on 4/2/2015.
//  Copyright (c) 2015年 Will. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TT.h"
@interface Tx : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) TT *TT;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSMutableArray *ad;
@end
