//
//  StudentInfo.m
//  part1
//
//  Created by 张军 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "StudentInfo.h"

@implementation StudentInfo

-(StudentInfo *)initWithName:(NSString *)name photo:(NSData *)photo{
    self = [super init];
    if (self) {
        _nameString = name;
        _photoData = photo;
    }
    return self;
}

@end
