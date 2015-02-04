//
//  ViewController.m
//  JsonMapObject
//
//  Created by Will on 4/2/2015.
//  Copyright (c) 2015年 Will. All rights reserved.
//

#import "ViewController.h"

#import "JsonMapObject.h"

#import "Text.h"

#import "StatusResult.h"
#import "Status.h"
#import "Ad.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self text1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)text1
{
    NSDictionary *dictEX = @{
                             @"name" : @"Jack",
                             @"icon" : @"lufy.png",
                             @"Tx":@{
                                     @"name" : @"JackTx",
                                     @"icon" : @"lufy.png",
                                     @"ad":@[
                                             @{
                                                 @"image" : @"ad01.png",
                                                 @"url" : @"http://www.ad01.com"
                                                 },
                                             @{
                                                 @"image" : @"ad02.png",
                                                 @"url" : @"http://www.ad02.com"
                                                 }
                                             ],
                                     @"TT":@{
                                             @"name" : @"TT",
                                             @"icon" : @"lufy.png"
                                             }
                                     }
                             };
    NSDictionary *replaceDict = @{
                                  @"ID":@"name",
                                  @"ad":[Ad class]
                                  };
    
    
    Text *text = [JsonMapObject JsonMapObjectWithClassName:@"Text" requestNSDictionay:dictEX replaceNSDictionary:replaceDict];
    NSLog(@"%@",text.name);
    NSLog(@"%@",text.Tx.name);
    NSLog(@"%@",text.Tx.TT.ID);
    
    
    for (Ad *ad in text.Tx.ad) {
        NSLog(@"%@",ad.image);
    }
}

-(void)text2
{
    NSDictionary *dict = @{
                           @"statuses" : @[
                                   @{
                                       @"text" : @"今天天气真不错！",
                                       
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png",
                                               @"TT" : @{@"name":@"TI"
                                                         }
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"明天去旅游了",
                                       
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png",
                                               @"TT":@{@"name":@"T2"
                                                       }
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"嘿嘿，这东西不错哦！",
                                       
                                       @"user" : @{
                                               @"name" : @"Jim",
                                               @"icon" : @"zero.png",
                                               @"TT":@{@"name":@"T3"
                                                       }
                                               }
                                       }
                                   
                                   ],
                           
                           @"ads" : @[
                                   @{
                                       @"image" : @"ad01.png",
                                       @"url" : @"http://www.ad01.com"
                                       },
                                   @{
                                       @"image" : @"ad02.png",
                                       @"url" : @"http://www.ad02.com"
                                       }
                                   ],
                           
                           @"totalNumber" : @"2014",
                           
                           @"previousCursor" : @"13476589",
                           
                           @"nextCursor" : @"13476599"
                           };
    
    
    
    NSDictionary *replace = @{
                              @"statuses" :[Status class],
                              @"ads":[Ad class],
                              @"ID":@"name"
                              };
    
    StatusResult *statusResult = [JsonMapObject JsonMapObjectWithClassName:@"StatusResult" requestNSDictionay:dict replaceNSDictionary:replace];
    for (Status *status in statusResult.statuses) {
        NSLog(@"%@\n",status.text);
        NSLog(@"%@\n",status.user.name);
        NSLog(@"%@\n",status.user.icon);
        NSLog(@"%@\n\n",status.user.TT.ID);
    }
    
    
    for (Ad *ad in statusResult.ads) {
        NSLog(@"%@",ad.url);
    }
}

@end
