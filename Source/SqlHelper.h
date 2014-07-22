//
//  SqlHelper.h
//  part1
//
//  Created by 张军 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class StudentInfo;

@interface SqlHelper : NSObject

+(SqlHelper *)sharedSqlHelper;
//打开数据库
-(BOOL)openDataBase;
//增加学生表
-(BOOL)createStuTable;
//向学生表中加入学生信息增加学生信息
-(BOOL)instertIntoStuTableWithStudent:(StudentInfo *)studentInfo;
//根据传入信息删除学生表中数据
-(BOOL)deleteStudentInfo:(StudentInfo *)studentInfo;
//根据传入的ID和学生信息更新
-(BOOL)updateStudentInfo:(StudentInfo *)studentInfo byId:(int)studentId;
//得到学生表中全部学生数据
-(NSMutableArray *)getAllStuInfosFromStuTable;
//关闭数据库
-(void)closeDataBase;

@end
