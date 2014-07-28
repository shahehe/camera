//
//  StudentSelectScene.m
//  part1
//
//  Created by 张军 on 14-7-26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "StudentSelectScene.h"
#import "SqlHelper.h"
#import "StudentInfo.h"

#define ScreenW [CCDirector sharedDirector].designSize.width
#define ScreenH [CCDirector sharedDirector].designSize.height

@interface StudentSelectScene ()
{
    CCSprite *_playerFrame;
    CCLabelTTF *_nameLabel;
    NSMutableArray *_studentArray;
}
@end

@implementation StudentSelectScene

+ (StudentSelectScene *)scene{
    return [[self alloc] init];
}

- (id)init{
    self = [super init];
    if (self) {
        //初始化学生数组
        _studentArray = [NSMutableArray array];
        [self setUI];
    }
    return self;
}

-(void)setUI{
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background];
    
    _playerFrame = [CCSprite spriteWithImageNamed:@"photo.png"];
    _playerFrame.position = ccp(ScreenW*0.5f, ScreenH*0.6);
    _playerFrame.scale = 1.5;
    [self addChild:_playerFrame];
    
    _nameLabel = [CCLabelTTF labelWithString:@"name" fontName:@"Verdana-Bold" fontSize:18.0f];
    _nameLabel.position = ccp(ScreenW*0.5f, ScreenH*0.15f);
    [self addChild:_nameLabel];
    
    CCButton *SSButton = [CCButton buttonWithTitle:@"[ back ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    SSButton.positionType = CCPositionTypeNormalized;
    SSButton.position = ccp(0.1f, 0.9f);
    [SSButton setTarget:self selector:@selector(backClicked)];
    [self addChild:SSButton];
    
}

-(void)onEnter{
    [super onEnter];
    //设置可触摸
    self.userInteractionEnabled = YES;
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
//    NSLog(@"touchBegan");
}
//触摸方法
-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
//    NSLog(@"touchEnded");
    CGPoint touchLoc = [touch locationInNode:self];
    //如果触摸到photo，则弹出相册／相机
    if (CGRectContainsPoint(_playerFrame.boundingBox, touchLoc)) {
        if (_studentArray.count == 0) {
            _studentArray = [[SqlHelper sharedSqlHelper] getAllStuInfosFromStuTable];
        }
        if (_studentArray.count > 0) {
            StudentInfo *studentInfo = _studentArray[arc4random()%_studentArray.count];
            [_studentArray removeObject:studentInfo];
            
            //设置照片
            UIImage *photoImage=[UIImage imageWithData:studentInfo.photoData];
            //照片到photo精灵中
            CGFloat imgScale;
            CGFloat imgH=photoImage.size.height;
            CGFloat imgW=photoImage.size.width;
            if (imgH>imgW) {
                imgScale=imgH/_playerFrame.contentSize.height;
            }else{
                imgScale=imgW/_playerFrame.contentSize.width;
            }
            NSLog(@"imgScale:%f",imgScale);
            CCTexture *texture = [[CCTexture alloc] initWithCGImage:photoImage.CGImage contentScale:imgScale];
            [_playerFrame setTexture:texture];
            //设置姓名
            _nameLabel.string = studentInfo.nameString;
        }
    }
}

-(void)backClicked{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

@end
