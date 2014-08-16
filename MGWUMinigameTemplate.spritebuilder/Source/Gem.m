//
//  Gem.m
//  MGWUMinigameTemplate
//
//  Created by judy mckelvey on 8/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gem.h"

@implementation Gem

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"gem";
}

@end
