//
//  SceneSendParams.h
//  part1
//
//  Created by 张军 on 14-7-5.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StudentInfo;

@interface SceneSendParams : NSObject

//插入旗标
@property (nonatomic,assign) BOOL dbIsInsert;
//更新旗标
@property (nonatomic,assign) BOOL dbIsUpdate;
//更新参数
@property (nonatomic,strong) StudentInfo *UpdataStuInfo;

+(SceneSendParams *)sharedParams;

@end
