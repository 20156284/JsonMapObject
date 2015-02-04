//
//  JsonMapObject.m
//  McAppIOS
//
//  Created by WillCheung on 14/8/22.
//  Copyright (c) 2014年 Will. All rights reserved.
//

#import "JsonMapObject.h"


static NSSet *foundationClasses;

@implementation JsonMapObject

/**
 *  初始化
 */
+(void)load{
    foundationClasses  = [NSSet setWithObjects:
                          [NSObject class],
                          [NSURL class],
                          [NSDate class],
                          [NSNumber class],
                          [NSDecimalNumber class],
                          [NSData class],
                          [NSMutableData class],
                          [NSArray class],
                          [NSMutableArray class],
                          [NSDictionary class],
                          [NSMutableDictionary class],
                          [NSString class],
                          [NSMutableString class], nil];
}




+ (id)JsonMapObjectWithClassName:(NSString *)classname requestNSDictionay:(NSDictionary *)dict replaceNSDictionary:(NSDictionary*)replaceDict {
    
    Class  tempClass = NSClassFromString(classname);
    //这里 在创建这个类实例之前 最好判断下 是否该对象存在；
    if(!tempClass){
        NSLog(@"I cannot find %@ class" ,classname);
        return nil;
    }
    // 如果存在 就创建你相应的实例对象
    id tempObj = [tempClass new];
    
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([tempObj class], &outCount); // 获取到所有的成员变量列表
    
    unsigned int count;
    objc_property_t *property_t_array = class_copyPropertyList([tempClass class], &count);
    
    if (replaceDict != nil) {
        // 遍历所有的成员变量
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = vars[i];
            NSString *propertyType = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
            
            objc_property_t pro_t = property_t_array[i];
            //得到属性名字的字符串
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(pro_t) encoding:NSUTF8StringEncoding];
            
            id value =  [dict objectForKey:propertyName];;
            //查看是否有代替的Key
            
            if (value == nil) {
                NSDictionary *newDict =  [self findKeyfromValue:propertyName withDictionary:replaceDict];
                value = [dict objectForKey:[newDict objectForKey:propertyName]];
            }
            
            
            //如果不是FromFoundation类型  回调
            if (![self isClassFromFoundation:propertyType]) {
                Class  suntempClass = NSClassFromString([self returnClassName:propertyType]);
                id suntempObj = [[suntempClass alloc] init];
                suntempObj = [self JsonMapObjectWithClassName:[self returnClassName:propertyType] requestNSDictionay:value replaceNSDictionary:replaceDict];
                [tempObj setValue:suntempObj forKey:propertyName];
            }
            else if ([value isKindOfClass:[NSArray class]]){
                NSDictionary *newDict = [self findKeyfromValue:propertyName withDictionary:replaceDict];
                if ([newDict objectForKey:propertyName] != nil) {
                    NSMutableArray *arrPro = [[NSMutableArray alloc] init];
                    NSArray *arrSun = [dict objectForKey:propertyName];
                    
                    for (NSDictionary *sunDict in arrSun) {
                        Class  suntempClass = [newDict objectForKey:propertyName];
                        NSString *strClassName = [NSString stringWithCString:object_getClassName(suntempClass) encoding:NSUTF8StringEncoding];
                        id suntempObj = [[suntempClass alloc] init];
                        suntempObj = [self JsonMapObjectWithClassName:strClassName requestNSDictionay:sunDict replaceNSDictionary:replaceDict];
                        [arrPro addObject:suntempObj];
                    }
                    [tempObj setValue:arrPro forKey:propertyName];
                }
                else
                {
                    [tempObj setValue:value forKey:propertyName];
                }
            }
            else{
                [tempObj setValue:value forKey:propertyName];
            }
            
        }
    }
    else
    {
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = vars[i];
            NSString *propertyType = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
            
            objc_property_t pro_t = property_t_array[i];
            //得到属性名字的字符串
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(pro_t) encoding:NSUTF8StringEncoding];
            
            //直接把json 的键设置成 类的属性名  实现 直接映射
            id value = [dict objectForKey:propertyName];
            //如果不是FromFoundation类型  回调
            if (![self isClassFromFoundation:propertyType]) {
                Class  suntempClass = NSClassFromString([self returnClassName:propertyType]);
                id suntempObj = [[suntempClass alloc] init];
                suntempObj = [self JsonMapObjectWithClassName:[self returnClassName:propertyType] requestNSDictionay:value replaceNSDictionary:replaceDict];
                [tempObj setValue:suntempObj forKey:propertyName];
            }
            else{
                [tempObj setValue:value forKey:propertyName];
            }
        }
    }
    
    
    free(vars);
    return tempObj;
}


/**
 *  查找相对应的替换字符串
 *
 *  @param value 需要替换的字段
 *  @param dict  字典
 *
 *  @return 返回查找到的字符串
 */
+ (NSDictionary *)findKeyfromValue:(NSString *)value withDictionary:(NSDictionary *)dict
{
    NSString *fromDictKey = nil;
    NSDictionary *newDict = nil;
    for (id key in [dict allKeys]) {
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            newDict = [self findKeyfromValue:value withDictionary:[dict objectForKey:key]];
        }
        else
        {
            if ([key isEqualToString:value]) {
                fromDictKey = [dict objectForKey:key];
                newDict = @{value:fromDictKey};
                break;
            }
        }
    }
    return newDict;
}

/**
 *  查找类名
 *
 *  @param className 字符创类名
 *
 *  @return 字符串的名称
 */
+ (NSString *)returnClassName:(NSString *)className{
    
    className = [className substringWithRange:NSMakeRange(2, className.length - 3)];
    return className;
}


/**
 *  判断是否FromFoundation 类型
 *
 *  @param strClass 字符串类型
 *
 *  @return 真假
 */
+ (BOOL)isClassFromFoundation:(NSString *)strClass{
    
    id typeClass;
    
    strClass = [strClass substringWithRange:NSMakeRange(2, strClass.length - 3)];
    
    typeClass = NSClassFromString(strClass);
    
    return [foundationClasses containsObject:typeClass];
}
@end
