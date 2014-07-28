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
#import "StudentSelectScene.h"

@interface MainScene ()

@end

@implementation MainScene

-(void)didLoadFromCCB{
    // StudentSelectScene button
    CCButton *SSButton = [CCButton buttonWithTitle:@"[ StudentSelect ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    SSButton.positionType = CCPositionTypeNormalized;
    SSButton.position = ccp(0.5f, 0.2f);
    [SSButton setTarget:self selector:@selector(SSButtonClicked:)];
    [self addChild:SSButton];
}


-(void)addBtnClick{
    NSLog(@"addBtnClick");
    [[SceneSendParams sharedParams] setDbIsInsert:YES];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"addMember"] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];

}

-(void)listBtnClick{
    NSLog(@"listBtnClick");
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"showMember"] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

-(void)SSButtonClicked:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[StudentSelectScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:0.5f]];
}

@end
