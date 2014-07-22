//
//  AddMemberScene.m
//  part1
//
//  Created by 张军 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "AddMemberScene.h"
#import "StudentInfo.h"
#import "SqlHelper.h"
#import "SceneSendParams.h"

@interface AddMemberScene ()<UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
{
    //显示photo的精灵
    CCSprite *_photo;
    //相机/相册中选择的照片
    UIImage *_photoImage;
    //名字
    CCTextField *_nameTextField;
}
@end

@implementation AddMemberScene

-(void)didLoadFromCCB{
//    NSLog(@"AddMemberScene:loaded");
}

-(void)onEnter{
    [super onEnter];
    NSLog(@"AddMemberScene:onEnter");
    //设置可触摸
    self.userInteractionEnabled=YES;
    if ([SceneSendParams sharedParams].dbIsUpdate&&[SceneSendParams sharedParams].UpdataStuInfo) {
        [self setStuInfo];
    }
}

//把要更新的数据显示出来
-(void)setStuInfo{
    StudentInfo *info=[SceneSendParams sharedParams].UpdataStuInfo;
    //显示名字
    _nameTextField.string = info.nameString;
    //获得照片
    _photoImage = [UIImage imageWithData:info.photoData];
    //照片到photo精灵中
    CGFloat imgScale;
    CGFloat imgH=_photoImage.size.height;
    CGFloat imgW=_photoImage.size.width;
    if (imgH>imgW) {
        imgScale=imgH/_photo.contentSize.height;
    }else{
        imgScale=imgW/_photo.contentSize.width;
    }
    NSLog(@"imgScale:%f",imgScale);
    CCTexture *texture = [[CCTexture alloc] initWithCGImage:_photoImage.CGImage contentScale:imgScale];
    [_photo setTexture:texture];
}

//点击返回的方法
-(void)back{
    NSLog(@"AddMemberScene:back");
    if ([SceneSendParams sharedParams].dbIsInsert) {
        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
    }else{
        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionFadeWithColor:[CCColor blackColor] duration:0.5]];
    }
    
}

//触摸方法
-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLoc = [touch locationInNode:self];
    //如果触摸到photo，则弹出相册／相机
    if (CGRectContainsPoint(_photo.boundingBox, touchLoc)) {
        NSLog(@"AddMemberScene:touch photo");
        //实例化照片控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        //设置代理
        imagePickerController.delegate = self;
        //判断摄像头设备是否可用
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            NSLog(@"设备摄像头不可用，在相册中选择照片");
            //设置照片的来源
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }else{
            //设置照片的来源
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        //设置照片的来源
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //设置照片可以编辑
        imagePickerController.allowsEditing = YES;
        //显示相册
        [[CCDirector sharedDirector].navigationController presentModalViewController:imagePickerController animated:YES];
        
    }
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{

}

#pragma mark 照片选择器的代理方法
//选择照片的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //编辑后的图片
    _photoImage = info[UIImagePickerControllerEditedImage];
    //照片到photo精灵中
    CGFloat imgScale;
    CGFloat imgH=_photoImage.size.height;
    CGFloat imgW=_photoImage.size.width;
    if (imgH>imgW) {
        imgScale=imgH/_photo.contentSize.height;
    }else{
        imgScale=imgW/_photo.contentSize.width;
    }
    NSLog(@"imgScale:%f",imgScale);
    CCTexture *texture = [[CCTexture alloc] initWithCGImage:_photoImage.CGImage contentScale:imgScale];
    [_photo setTexture:texture];
    //隐藏模态控制器
    [[CCDirector sharedDirector].navigationController dismissViewControllerAnimated:YES completion:nil];
}

//取消选择的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"AddMemberScene:cancel");
    [[CCDirector sharedDirector].navigationController dismissViewControllerAnimated:YES completion:nil];
}

//点击OK的方法
-(void)savePhotoAndName{
    if (!_photoImage) {
        NSLog(@"AddMemberScene:no photo");
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择照片" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([_nameTextField.string isEqualToString:@""]||!_nameTextField.string) {
        NSLog(@"AddMemberScene:no name");
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写姓名" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSLog(@"OK,%@",_nameTextField.string);
    if ([SceneSendParams sharedParams].dbIsInsert) {
        //存储照片,姓名
        [self insertInfo];
    }
    if ([SceneSendParams sharedParams].dbIsUpdate&&[SceneSendParams sharedParams].UpdataStuInfo) {
        //更新数据
        [self updataInfo];
    }
    
}

-(void)insertInfo{
    StudentInfo *oneStudent=[[StudentInfo alloc] init];
    oneStudent.nameString=_nameTextField.string;
    NSData *photoData;
    if (UIImagePNGRepresentation(_photoImage) == nil) {
        photoData = UIImageJPEGRepresentation(_photoImage, 1);
    } else {
        photoData = UIImagePNGRepresentation(_photoImage);
    }
    oneStudent.photoData=photoData;
    
    if ([[SqlHelper sharedSqlHelper] instertIntoStuTableWithStudent:oneStudent]) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        _nameTextField.string=@"";
        _photoImage=nil;
        _photo.spriteFrame=[CCSpriteFrame frameWithImageNamed:@"photo.png"];
    }
}

-(void)updataInfo{
    int updataId=[SceneSendParams sharedParams].UpdataStuInfo.stuId;
    NSData *photoData;
    if (UIImagePNGRepresentation(_photoImage) == nil) {
        photoData = UIImageJPEGRepresentation(_photoImage, 1);
    } else {
        photoData = UIImagePNGRepresentation(_photoImage);
    }
    StudentInfo *updateStuInfo=[[StudentInfo alloc] initWithName:_nameTextField.string photo:photoData];
    
    if ([[SqlHelper sharedSqlHelper] updateStudentInfo:updateStuInfo byId:updataId]) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"更新成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        _nameTextField.string=@"";
        _photoImage=nil;
        _photo.spriteFrame=[CCSpriteFrame frameWithImageNamed:@"photo.png"];
        [[SceneSendParams sharedParams] setDbIsInsert:YES];
    }
}
@end
