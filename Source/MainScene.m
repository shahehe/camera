//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

#import "AddMemberScene.h"
#import "SceneSendParams.h"

@interface MainScene ()

@end

@implementation MainScene

-(void)addBtnClick{
    NSLog(@"addBtnClick");
    [[SceneSendParams sharedParams] setDbIsInsert:YES];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"addMember"] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];

}

-(void)listBtnClick{
    NSLog(@"listBtnClick");
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"showMember"] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

@end
