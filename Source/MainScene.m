#import "MainScene.h"
#import "VerletRope.h"
#import "CCPhysics+ObjectiveChipmunk.h"

#define ROPE_SAG_FACTOR 1.2

@implementation MainScene
{
    VerletRope *_ropeNode;
    
    BOOL _freeBallMode;
    
    CGPoint _secondItemPosition;
}

- (void)didLoadFromCCB
{
    _ropeNode = [VerletRope ropeFromSavedDataBodyA:_nailA bodyB:_nailB];
    if (_ropeNode == nil)
    {
        // DEVELOPMENT CASE - ROPE_SAG_FACTOR should be around 1.2
        float len = ccpDistance([_nailA position], [_nailB position]) * ROPE_SAG_FACTOR;
        _ropeNode = [[VerletRope alloc] initWithLength:len bodyA:_nailA bodyB:_nailB];
    }
    else
    {
        // SHIPPED APP CASE
        [_ropeDataMessage setString:@"Rope setup loaded from data!"];
    }
    
    [self addChild:_ropeNode];
}

- (void)freeBallPressed:(id)sender
{
    if (_freeBallMode)
    {
        CCPhysicsJoint *ropeJoint = (CCPhysicsJoint *)[[[_ball physicsBody] joints] firstObject];
        NSLog(@"Removing rope joint: %@", ropeJoint);
        [ropeJoint invalidate];
        
//        [[_physicsNode space] addPostStepBlock:^{
//            [_ball removeFromParent];
//        } key:_ball];
        
        // create a new rope from the first nail to the second nail
        VerletRope *nailRope = [VerletRope ropeFromSavedDataBodyA:_nailA bodyB:_nailB];
        if (nailRope == nil)
        {
            [_ropeDataMessage setString:@"Bake the rope data before trying new rope"];
        }
        else
        {
            [_ropeDataMessage setString:@"Rope setup loaded from data!"];
        }
        
        // make the ball invisible/no collisions and second nail visible/add collision
        [_ball setVisible:NO];
        [[_ball physicsBody] setSensor:YES];
        [_nailB setVisible:YES];
        [[_nailB physicsBody] setSensor:NO];
        
        // get rid of the old rope, replace with new
        [_ropeNode removeFromParent];
        _ropeNode = nailRope;
        [self addChild:_ropeNode];
        
        [_freeBallButton setTitle:@"Free ball"];
        _freeBallMode = NO;
    }
    else
    {
        // go to free ball mode
        // move ball to where the second nail is
        [_ball setPosition:[_nailB position]];

        // create a new rope from the first nail to the ball
        VerletRope *ballRope = [VerletRope ropeFromSavedDataBodyA:_nailA bodyB:_ball];
        if (ballRope == nil)
        {
            [_ropeDataMessage setString:@"Bake the rope data before trying free ball"];
        }
        else
        {
            [_ropeDataMessage setString:@"Rope setup loaded from data!"];
        }
        
        // make the ball visible and second nail invisible
        [_ball setVisible:YES];
        [[_ball physicsBody] setSensor:NO];
        [_nailB setVisible:NO];
        [[_nailB physicsBody] setSensor:YES];
        
        // get rid of the old rope, replace with new
        [_ropeNode removeFromParent];
        _ropeNode = ballRope;
        [self addChild:_ropeNode];
        [_ropeNode setUpRopeJointWithAnchorA:[_nailA anchorPointInPoints] anchorB:[_ball anchorPointInPoints]];
        
        [_freeBallButton setTitle:@"Two Pins"];
        _freeBallMode = YES;
    }
}

- (void)saveDataPressed:(id)sender
{
    [_ropeNode saveRopeData];
    
    [_ropeDataMessage setString:@"Rope data saved!"];
}

@end
