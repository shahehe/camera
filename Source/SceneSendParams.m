//
//  SceneSendParams.m
//  part1
//
//  Created by 张军 on 14-7-5.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "SceneSendParams.h"

static SceneSendParams *params=nil;
@implementation SceneSendParams

+(SceneSendParams *)sharedParams{
    if (params==nil) {
        params=[[self alloc] init];
    }
    return params;
}

-(id)init{
    self=[super init];
    if (self) {
        _dbIsInsert=NO;
        _dbIsUpdate=NO;
        _UpdataStuInfo=nil;
    }
    return self;
}

-(void)setDbIsInsert:(BOOL)dbIsInsert{
    if (dbIsInsert) {
        _dbIsInsert=YES;
        _dbIsUpdate=NO;
    }else{
        _dbIsInsert=NO;
    }
}

-(void)setDbIsUpdate:(BOOL)dbIsUpdate{
    if (dbIsUpdate) {
        _dbIsUpdate=YES;
        _dbIsInsert=NO;
    }else{
        _dbIsUpdate=NO;
    }
}

@end
