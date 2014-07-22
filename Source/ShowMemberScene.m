//
//  ShowMemberScene.m
//  part1
//
//  Created by 张军 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "ShowMemberScene.h"
#import "SqlHelper.h"
#import "StudentInfo.h"
#import "SceneSendParams.h"

@interface ShowMemberScene ()
{
    //当前学生的照片
    CCSprite *_photo;
    //显示当前学生序号＋1，学生总数，学生名字
    CCLabelTTF *_nameLabel;
    //上一个按钮
    CCButton *_previousBtn;
    //下一个按钮
    CCButton *_nextBtn;
    //删除按钮
    CCButton *_deleteBtn;
    //数据库中获取的所有学生数组
    NSMutableArray *_studentsArray;
    //当前学生序号
    NSInteger _currentStudent;
}
//@property (nonatomic,assign) NSInteger currentStudent;
@end

@implementation ShowMemberScene

-(void)didLoadFromCCB{
//    NSLog(@"load");
//    self.userInteractionEnabled = YES;
//    //读取所有学生数据，放入数组中
//    _studentsArray=[[SqlHelper sharedSqlHelper] getAllStuInfosFromStuTable];
//    self.currentStudent=0;
//    if (_studentsArray.count>0) {
//        //得到第一个学生数据
//        StudentInfo *firstStudent=(StudentInfo *)_studentsArray[_currentStudent];
//        //显示第一个学生的数据
//        [self showStudent:firstStudent];
//    }
}

-(void)onEnter{
    [super onEnter];
    NSLog(@"ShowMemberScene:onEnter");
    self.userInteractionEnabled = YES;
    //读取所有学生数据，放入数组中
    _studentsArray=[[SqlHelper sharedSqlHelper] getAllStuInfosFromStuTable];
    self.currentStudent=0;
    if (_studentsArray.count>0) {
        //得到第一个学生数据
        StudentInfo *firstStudent=(StudentInfo *)_studentsArray[_currentStudent];
        //显示第一个学生的数据
        [self showStudent:firstStudent];
    }
}

//返回按钮的方法
-(void)back{
    NSLog(@"ShowMemberScene:back");
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}

//设置显示当前学生序号
-(void)setCurrentStudent:(NSInteger)currentStudent{
    _currentStudent=currentStudent;
    _deleteBtn.enabled=YES;
    if (_studentsArray.count==0) {
        _previousBtn.enabled=NO;
        _nextBtn.enabled=NO;
        _deleteBtn.enabled=NO;
    }else if (_currentStudent==0&&_studentsArray.count==1) {
        _previousBtn.enabled=NO;
        _nextBtn.enabled=NO;
    }else if (_currentStudent==0&&_studentsArray.count>1) {
        _previousBtn.enabled=NO;
        _nextBtn.enabled=YES;
    }else if (_currentStudent==_studentsArray.count-1){
        _nextBtn.enabled=NO;
        _previousBtn.enabled=YES;
    }else{
        _previousBtn.enabled=YES;
        _nextBtn.enabled=YES;
    }
}

//上一个按钮的方法
-(void)previous{
    NSLog(@"ShowMemberScene:previous");
    //得到上一个学生数据
    self.currentStudent=_currentStudent-1;
    StudentInfo *oneStudent=(StudentInfo *)_studentsArray[_currentStudent];
    //显示学生的数据
    [self showStudent:oneStudent];
}
//下一个按钮的方法
-(void)next{
    NSLog(@"ShowMemberScene:next");
    //得到下一个学生数据
    self.currentStudent=_currentStudent+1;
    StudentInfo *oneStudent=(StudentInfo *)_studentsArray[_currentStudent];
    //显示学生的数据
    [self showStudent:oneStudent];
}

//显示学生的数据
-(void)showStudent:(StudentInfo *)student{
    _nameLabel.string=[NSString stringWithFormat:@"%d/%d,%@",_currentStudent+1,_studentsArray.count,student.nameString];
    UIImage *photoImage=[UIImage imageWithData:student.photoData];
    //照片到photo精灵中
    CGFloat imgScale;
    CGFloat imgH=photoImage.size.height;
    CGFloat imgW=photoImage.size.width;
    if (imgH>imgW) {
        imgScale=imgH/_photo.contentSize.height;
    }else{
        imgScale=imgW/_photo.contentSize.width;
    }
    NSLog(@"imgScale:%f",imgScale);
    CCTexture *texture = [[CCTexture alloc] initWithCGImage:photoImage.CGImage contentScale:imgScale];
    [_photo setTexture:texture];
}

//删除按钮的方法
-(void)delete{
    //得到当前学生数据
    StudentInfo *currentStudent=(StudentInfo *)_studentsArray[_currentStudent];
    [[SqlHelper sharedSqlHelper] deleteStudentInfo:currentStudent];
    //读取所有学生数据，放入数组中
    _studentsArray=[[SqlHelper sharedSqlHelper] getAllStuInfosFromStuTable];
    self.currentStudent=0;
    if (_studentsArray.count>0) {
        //得到第一个学生数据
        StudentInfo *firstStudent=(StudentInfo *)_studentsArray[_currentStudent];
        //显示第一个学生的数据
        [self showStudent:firstStudent];
    }else{
        _photo.spriteFrame=[CCSpriteFrame frameWithImageNamed:@"photo.png"];
        _nameLabel.string=@"no student";
    }
}

//触摸方法
-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLoc = [touch locationInNode:self];
    //如果触摸到photo，则弹出相册／相机
    if (CGRectContainsPoint(_photo.boundingBox, touchLoc)) {
        NSLog(@"ShowMemberScene:touch photo");
        if (_studentsArray.count>0) {
            [[SceneSendParams sharedParams] setDbIsUpdate:YES];
            [[SceneSendParams sharedParams] setUpdataStuInfo:(StudentInfo *)_studentsArray[_currentStudent]];
        }else{
            [[SceneSendParams sharedParams] setDbIsInsert:YES];
            [[SceneSendParams sharedParams] setUpdataStuInfo:nil];
        }
        [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"addMember"] withTransition:[CCTransition transitionFadeWithColor:[CCColor blackColor] duration:0.5]];
    }
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
}
@end
