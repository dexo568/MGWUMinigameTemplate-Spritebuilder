//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/6/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MyMinigame.h"

@implementation MyMinigame {
    CCNode *_currentPathBit;
    CCPhysicsNode *_physicsNode;
    CCNode *_levelNode;
    CCLabelTTF *_stuckLabel;
    CCNode *_stuckPopup;
    int score;
    int stuckTimer;
}

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        self.userInteractionEnabled = TRUE;
        self.instructions = @"Draw lines to control your character as they fall. Each gem is worth five points. The game is over when you hit the ground, or when your character stops moving when you get stuck.";
    }
    return self;
}

-(void)didLoadFromCCB {
    score=0;
    stuckTimer=0;
    _physicsNode.collisionDelegate = self;
    // Set up anything connected to Sprite Builder here
    int levelNum = arc4random_uniform(3) + 1;
    if(levelNum==1){
        CCScene *level = [CCBReader loadAsScene:@"Level1"];
        [_levelNode addChild:level];
    }else if (levelNum==2){
        CCScene *level = [CCBReader loadAsScene:@"Level2"];
        [_levelNode addChild:level];
    }else{
        CCScene *level = [CCBReader loadAsScene:@"Level3"];
        [_levelNode addChild:level];
    }
    
    
    // We're calling a public method of the character that tells it to jump!
    //[self.hero jump];
    
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
}

-(void)update:(CCTime)delta {
    self.position = ccp(0, -200+(-568*self.hero.position.y));
    if(self.hero.position.y < -0.915){
        _stuckPopup.positionInPoints = self.hero.positionInPoints;
        _stuckPopup.position = ccp(160, _stuckPopup.position.y);
        _stuckLabel.string = [NSString stringWithFormat:@"You're done! \n Score: %d", score];
    }else{
        printf("Hero position registered at (%f,%f)\n", self.hero.position.x, self.hero.position.y);
        printf("popup position registered at (%f,%f)\n", _stuckPopup.position.x, _stuckPopup.position.y);
        if(labs([self hero].physicsBody.velocity.x) < .1 && labs([self hero].physicsBody.velocity.y) < .1 && stuckTimer > 10){
            _stuckPopup.positionInPoints = self.hero.positionInPoints;
            _stuckPopup.position = ccp(160, _stuckPopup.position.y);
            _stuckLabel.string = [NSString stringWithFormat:@"You're stuck! \n Score: %d", score];
            
        }
        if(labs([self hero].physicsBody.velocity.x) < .1 && labs([self hero].physicsBody.velocity.y) < .1){
            stuckTimer+=1;
        }else{
            stuckTimer=0;
        }
        if([self hero].physicsBody.velocity.x > 0){
            [[self hero].animationManager runAnimationsForSequenceNamed:@"AnimSideRoll"];
        }else{
            [[self hero].animationManager runAnimationsForSequenceNamed:@"AnimSideRoll2"];
        }
    }
//    printf("%f\n", self.hero.position.y);
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //printf("Touch registered at (%f,%f)\n", [touch locationInNode:self].x, [touch locationInNode:self].y);
    _currentPathBit = [CCBReader load:@"PathBit"];
    //_currentPathBit.position = [touch locationInNode:self];
    //_currentPathBit.position = [_physicsNode convertToNodeSpace:_currentPathBit.position];
    //_currentPathBit.position = ccp([touch locationInNode:self].x, [touch locationInNode: self].y+568);
    //printf("Node coordinates at (%f,%f)\n", _currentPathBit.position.x, _currentPathBit.position.y);
    //[_physicsNode addChild:_currentPathBit];
    //printf("Node touch coordinates at (%f,%f)\n", [touch locationInNode:_physicsNode].x,[touch locationInNode:_physicsNode].y);
    //[_physicsNode addChild:_currentPathBit];
    CGPoint bitPosition = [self convertToWorldSpace:[touch locationInNode:self]];
    _currentPathBit.position = [_physicsNode convertToNodeSpace:bitPosition];
    [_physicsNode addChild:_currentPathBit];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    _currentPathBit = [CCBReader load:@"PathBit"];
    CGPoint bitPosition = [self convertToWorldSpace:[touch locationInNode:self]];
    _currentPathBit.position = [_physicsNode convertToNodeSpace:bitPosition];
    [_physicsNode addChild:_currentPathBit];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair gem:(CCNode *)nodeA wildcard:(CCNode *)nodeB{
    [nodeA removeFromParent];
    score+=5;
    printf("Score: %i", score);
    return NO;
}

-(void)endMinigame {
    // Be sure you call this method when you end your minigame!
    // Of course you won't have a random score, but your score *must* be between 1 and 100 inclusive
    //[self endMinigameWithScore:arc4random()%100 + 1];
    [self endMinigameWithScore:score];
}


// DO NOT DELETE!
-(MyCharacter *)hero {
    return (MyCharacter *)self.character;
}
// DO NOT DELETE!

@end
