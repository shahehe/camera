//
//  StudentInfo.h
//  part1
//
//  Created by 张军 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentInfo : NSObject

@property (nonatomic,assign) int stuId;
@property (nonatomic,strong) NSData *photoData;
@property (nonatomic,copy) NSString *nameString;

-(StudentInfo *)initWithName:(NSString *)name photo:(NSData *)photo;

@end
