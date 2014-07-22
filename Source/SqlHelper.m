//
//  SqlHelper.m
//  part1
//
//  Created by 张军 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "SqlHelper.h"
#import "StudentInfo.h"

@interface SqlHelper ()
{
    sqlite3 *dataBase;
}

@end

static SqlHelper *helper = nil;
@implementation SqlHelper

+(SqlHelper *)sharedSqlHelper{
    if (helper == nil) {
        helper = [[self alloc] init];
    }
    return helper;
}

// 定义一个方法，获取数据库文件的保存路径。
- (NSString*) dbPath
{
	// 获取应用的Documents路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [NSString stringWithFormat:@"%@/GameDataBase.db"
            , documentsDirectory];
}

//打开数据库
-(BOOL)openDataBase{
    // 新建和打开数据库，database变量保存了打开的数据库的指针
    if(sqlite3_open([[self dbPath] UTF8String], &dataBase)==SQLITE_OK){
        NSLog(@"open sqlite db ok.");
        return YES;
    }
    NSLog( @"can not open sqlite db " );
    return NO;
}

//关闭数据库
-(void)closeDataBase{
    sqlite3_close(dataBase);
}


//增加学生表
-(BOOL)createStuTable{
    [self openDataBase];
    char *errorMsg;
    const char *createSql="create table if not exists student_info \
                            (_id integer primary key autoincrement,\
                            name,\
                            photo)";
    if (sqlite3_exec(dataBase, createSql, NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        NSLog(@"create ok.");
        [self closeDataBase];
        return YES;
    }
    NSLog( @"can not create table" );
    [self closeDataBase];
    return NO;
}

//向学生表中加入学生信息增加学生信息
-(BOOL)instertIntoStuTableWithStudent:(StudentInfo *)studentInfo{
    [self openDataBase];
    char *errorMsg;
    const char *createSql="create table if not exists student_info \
    (_id integer primary key autoincrement,\
    name,\
    photo)";
    if (sqlite3_exec(dataBase, createSql, NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        NSLog(@"create ok.");
        //插入数据
        const char * insertSQL = "insert into student_info values(null, ? , ?)";
        sqlite3_stmt * stmt;
        // 预编译SQL语句，stmt变量保存了预编译结果的指针
        int insertResult = sqlite3_prepare_v2(dataBase, insertSQL, -1, &stmt, nil);
        // 如果预编译成功
        if (insertResult == SQLITE_OK)
        {
            // 为第一个?占位符绑定参数
            sqlite3_bind_text(stmt, 1,[studentInfo.nameString UTF8String], -1, SQLITE_TRANSIENT);
            // 为第二个?占位符绑定参数
            sqlite3_bind_blob(stmt, 2,[studentInfo.photoData bytes] , [studentInfo.photoData length], SQLITE_TRANSIENT);
            // 执行SQL语句
            sqlite3_step(stmt);
        }
        else {
            NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dataBase));
        }
        sqlite3_finalize(stmt);
        //关闭数据库
        [self closeDataBase];
        return YES;
    }
    NSLog( @"can not create table" );
    [self closeDataBase];
    return NO;

}

//得到学生表中全部学生数据
-(NSMutableArray *)getAllStuInfosFromStuTable{
    [self openDataBase];
    const char * selectSQL = "select * from student_info";
    sqlite3_stmt * stmt;
    // 预编译SQL语句，stmt变量保存了预编译结果的指针
    int queryResult = sqlite3_prepare_v2(dataBase, selectSQL, -1, &stmt, nil);
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 如果预编译成功
    if(queryResult == SQLITE_OK)
    {
        // 采用循环多次执行sqlite3_step()函数，并从中取出查询结果
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            // 分别获取当前行的不同列的查询数据
            int word_id = sqlite3_column_int(stmt , 0);
            char* word = (char*)sqlite3_column_text(stmt , 1);
            int length = sqlite3_column_bytes(stmt, 2);
            NSData *photoData = [NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:length];
            // 将当前行的数据封装成StudentInfo对象
            StudentInfo *oneStudent=[[StudentInfo alloc] initWithName:[NSString stringWithUTF8String:word] photo:photoData];
            oneStudent.stuId=word_id;
            [result addObject:oneStudent];
        }
    }
    // 关闭数据库
    [self closeDataBase];
    return result;
}

//根据传入信息删除学生表中数据
-(BOOL)deleteStudentInfo:(StudentInfo *)studentInfo{
    NSLog(@"deleteStudentInfo");
    [self openDataBase];
    //删除数据
    const char * deleteSQL = "delete from student_info where _id = ?";
    sqlite3_stmt * stmt;
    // 预编译SQL语句，stmt变量保存了预编译结果的指针
    int insertResult = sqlite3_prepare_v2(dataBase, deleteSQL, -1, &stmt, nil);
    // 如果预编译成功
    if (insertResult == SQLITE_OK)
    {
        // 为第一个?占位符绑定参数
        sqlite3_bind_int(stmt, 1, studentInfo.stuId);
        // 执行SQL语句
        sqlite3_step(stmt);
    }
    else {
        NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dataBase));
    }
    sqlite3_finalize(stmt);
    //关闭数据库
    [self closeDataBase];
    return YES;
}

//根据传入的ID和学生信息更新
-(BOOL)updateStudentInfo:(StudentInfo *)studentInfo byId:(int)studentId{
    NSLog(@"updateStudentInfo");
    [self openDataBase];
    //更新数据数据
    const char * deleteSQL = "update student_info set name=?,photo=? where _id=?";
    sqlite3_stmt * stmt;
    // 预编译SQL语句，stmt变量保存了预编译结果的指针
    int insertResult = sqlite3_prepare_v2(dataBase, deleteSQL, -1, &stmt, nil);
    // 如果预编译成功
    if (insertResult == SQLITE_OK)
    {
        // 为第1个?占位符绑定参数
        sqlite3_bind_text(stmt, 1,[studentInfo.nameString UTF8String], -1, SQLITE_TRANSIENT);
        // 为第2个?占位符绑定参数
        sqlite3_bind_blob(stmt, 2,[studentInfo.photoData bytes] , [studentInfo.photoData length], SQLITE_TRANSIENT);
        // 为第3个?占位符绑定参数
        sqlite3_bind_int(stmt, 3, studentId);
        // 执行SQL语句
        sqlite3_step(stmt);
    }
    else {
        NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dataBase));
    }
    sqlite3_finalize(stmt);
    //关闭数据库
    [self closeDataBase];
    return YES;

}

@end
