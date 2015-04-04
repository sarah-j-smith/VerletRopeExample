@interface MainScene : CCNode

@property (nonatomic, strong) CCButton *freeBallButton;
@property (nonatomic, strong) CCButton *saveDataButton;

@property (nonatomic, strong) CCLabelTTF *ropeDataMessage;

@property (nonatomic, strong) CCSprite *nailA;
@property (nonatomic, strong) CCSprite *nailB;
@property (nonatomic, strong) CCSprite *ball;

@property (nonatomic, weak) CCPhysicsNode *physicsNode;

@end
