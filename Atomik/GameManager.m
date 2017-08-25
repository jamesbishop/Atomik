//
//  GameManager.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "GameManager.h"
#import "SynthesizeSingleton.h"

#pragma mark -
#pragma mark Private interface

@interface GameManager (Private)

- (void)loadGameWithStage:(int)newStage withLevel:(int)newLevel fromServer:(BOOL)newServer;

- (void)spawn:(float)delta;
- (void)movements:(AbstractMolecule*)molecule;
- (void)clipping:(AbstractMolecule*)molecule;
- (void)collisions:(AbstractMolecule*)molecule;
- (BOOL)intersect:(AbstractMolecule*)a with:(AbstractMolecule*)b;

- (void)updateProgress:(AbstractMolecule*)molecule;
- (void)updateScore:(AbstractMolecule*)molecule;
- (void)updateBonus:(AbstractMolecule*)molecule;

- (AbstractMolecule*)createMoleculeForPod:(AbstractSpawnpod*)spawnpod;
- (void)launchMoleculeFromPod:(AbstractSpawnpod*)spawnpod;
- (BOOL)isSafeToSpawnMolecule:(AbstractMolecule*)molecule;
- (void)openNextSteamPodOnCollision;

- (int)calculatePlayerProgress;

- (void)dropMolecule:(AbstractMolecule*)molecule inSinkhole:(AbstractSinkhole*)sinkhole;
- (void)dropMolecule:(AbstractMolecule*)molecule;
- (void)missMolecule:(AbstractMolecule*)molecule;
- (void)tapMolecule:(AbstractMolecule*)molecule;

- (void)updatePowerUps:(float)delta;

- (void)slowMotion:(AbstractMolecule*)molecule;
- (void)timeBonus:(AbstractMolecule*)molecule;
- (void)doubleDamage:(AbstractMolecule*)molecule;
- (void)quadDamage:(AbstractMolecule*)molecule;
- (void)destruction:(AbstractMolecule*)molecule;

@end

@implementation GameManager

@synthesize molecules;
@synthesize hints;
@synthesize powerups;
@synthesize level;
@synthesize background;
@synthesize scoreboard;
@synthesize pipeline;
@synthesize livesAllowed;
@synthesize livesRemaining;
@synthesize activePowerUp;
@synthesize timer;

SYNTHESIZE_SINGLETON_FOR_CLASS(GameManager);

// We are loading the game manager, so we need to define all the variables for the entire game cycle. This will
// not be called again, so its need to be values that are used for the continuity of the game. Game data which
// is specific to each level and stage should be defined in SETUP and destroyed using TEARDOWN at the end of 
// each stage. We also need to define variables which manage the status of the rendering pipeline in here.
- (id)init {
    if (self = [super init]) {
        // Load the molecule graphics for the entire gaming system.
        //NSLog(@"Loading Game Manager ...");
        
        _soundManager = [SoundManager sharedSoundManager];
        _imageManager = [ImageManager sharedImageManager];
        _progressManager = [ProgressManager sharedProgressManager];
        _networkManager = [NetworkManager sharedNetworkManager];
        
        [_soundManager setFxVolume:1.0f];
        [_soundManager setMusicVolume:0.1f];
        
        [_soundManager loadSoundWithKey:COLLISION_KEY soundFile:@"Explode_Atom.mp3"];
        [_soundManager loadSoundWithKey:@"SpawnPod" soundFile:@"Spawn_Atom.mp3"];
        [_soundManager loadSoundWithKey:@"SpawnPod_1" soundFile:@"Spawn_Speed_1.mp3"];
        [_soundManager loadSoundWithKey:@"SpawnPod_2" soundFile:@"Spawn_Speed_2.mp3"];
        [_soundManager loadSoundWithKey:@"SpawnPod_3" soundFile:@"Spawn_Speed_3.mp3"];
        [_soundManager loadSoundWithKey:@"SpawnPod_4" soundFile:@"Spawn_Speed_4.mp3"];
        
        [_soundManager loadSoundWithKey:@"SteamPod" soundFile:@"Spawn_Steam.mp3"];

        [_soundManager loadSoundWithKey:DROP_SUCCESS_KEY soundFile:@"Drop_Success.mp3"];
        [_soundManager loadSoundWithKey:DROP_FAILURE_KEY soundFile:@"Drop_Failure.mp3"];

        [_soundManager loadSoundWithKey:SPEED_BOOST_KEY soundFile:@"Powerup_1.mp3"];
        [_soundManager loadSoundWithKey:TIME_BONUS_KEY soundFile:@"Powerup_2.mp3"];
        [_soundManager loadSoundWithKey:DOUBLE_DAMAGE_KEY soundFile:@"Powerup_3.mp3"];
        [_soundManager loadSoundWithKey:QUAD_DAMAGE_KEY soundFile:@"Powerup_4.mp3"];
        [_soundManager loadSoundWithKey:TOTAL_DESTRUCTION_KEY soundFile:@"Powerup_5.mp3"];

        [_soundManager loadSoundWithKey:TIME_EXPIRED_KEY soundFile:@"Time_Expired.mp3"];
        [_soundManager loadSoundWithKey:FINAL_LIFE_KEY soundFile:@"Final_Life.mp3"];

        // Load the molecule graphics for the entire gaming system.
        for(int i=1; i <= GAME_MOLECULES; i++) {
            NSString *key = [NSString stringWithFormat:@"Molecule_%d", i];
            
            Image *molecule = [[Image alloc] initWithImage:key width:50 height:50];
            [_imageManager addImage:molecule andKey:key];
            [molecule release];
        }

        // Load the molecule graphics for the entire gaming system.
        for(int i=1; i <= GAME_MINICULES; i++) {
            NSString *key = [NSString stringWithFormat:@"Minicule_%d", i];

            // ============================================================
            // Version v1.0.1: Added high definition (retina) graphics
            // for minicules, as previously were just basic formats.
            // ============================================================
            Image *minicule = [[Image alloc] initWithImage:key width:32 height:32];
            [_imageManager addImage:minicule andKey:key];
            [minicule release];
        }

        // Load the sinkhole graphics for the entire gaming system.
        for(int i=1; i <= GAME_SINKHOLES; i++) {
            NSString *key = [NSString stringWithFormat:@"Sinkhole_%d", i];
            
            Image *sinkhole = [[Image alloc] initWithImage:key width:64 height:64];
            [_imageManager addImage:sinkhole andKey:key];
            [sinkhole release];
        }

        // Load the spawnpod graphics for the entire gaming system.
        [_imageManager addImageWithName:@"SpawnPod_(64x64).png" andKey:@"SpawnPod"];
        [_imageManager addImageWithName:@"SteamPod_0_(40x40).png" andKey:@"SteamPod_0"];
        [_imageManager addImageWithName:@"SteamPod_1_(40x40).png" andKey:@"SteamPod_1"];
        
        // Load the various different types of explosions,
        explosions = [[NSMutableArray alloc] init];
        
        for(int i=1; i <= 6; i++) {
            NSString *sheetName = [NSString stringWithFormat:@"Explosion_%d_(256x256).png", i];
            SpriteSheet *sheet = [[SpriteSheet alloc] initWithImageNamed:sheetName spriteWidth:64 spriteHeight:64 spacing:0 imageScale:1];

            Animation *animation = [[Animation alloc] init];
            for(int row=0; row < 4; row++) {
                for(int col=0; col < 4; col++) {
                    [animation addFrameWithImage:[sheet getSpriteAtX:col y:row] delay:0.05f];
                }
            }
            [animation setRunning:NO];
            [animation setRepeat:NO];
            
            [explosions addObject:animation];
            
            [sheet release];
            [animation release];
        }
        
        hints = [[NSMutableArray alloc] init];

        powerups = [[NSMutableArray alloc] init];
        for(int i=1; i <= GAME_MINICULES; i++) {
            NSString *key = [NSString stringWithFormat:@"Powerup_%d", i];
            
            Image *powerup = [[Image alloc] initWithImage:key width:128 height:32];
            [powerups addObject:powerup];
            [powerup release];
        }
 
        currentStage = 0;
        currentLevel = 0;
        
        _width = [[UIScreen mainScreen] bounds].size.width;
        _height = [[UIScreen mainScreen] bounds].size.height;
        _centreX = (int)(_width / 2);
        _centreY = (int)(_height / 2);
        
        serverGame = NO;
    }
    
    return self;
}

- (void)loadGameWithStage:(int)newStage withLevel:(int)newLevel fromServer:(BOOL)newServer{
    
    NSLog(@"Loading Game: Stage=(%d) Level=(%d) ...", newStage, newLevel);
    
    LevelManager *levelManager = [LevelManager sharedLevelManager];
    level = [levelManager loadFromDeviceWithStage:newStage andLevel:newLevel andWidth:_width andHeight:_height];
    
    currentStage = newStage;
    currentLevel = newLevel;
    serverGame = newServer;
    
#ifdef DEBUG
    /*
    NSLog(@"==============================================");
    NSLog(@"     Title: %@", [level title]);
    NSLog(@"Background: %@", [level background]);
    NSLog(@"  Pipeline: %@", [level pipeline]);
    NSLog(@"Scoreboard: %@", [level scoreboard]);
    NSLog(@"     Music: %@", [level music]);
    NSLog(@"  Duration: %f", [level duration]);
    NSLog(@"     Lives: %d", [level lives]);
    NSLog(@"    Target: %f", [level target]);
    NSLog(@" Sinkholes: %lu", (unsigned long)[[level sinkholes] count]);
    NSLog(@" Spawnpods: %lu", (unsigned long)[[level spawnpods] count]);
    NSLog(@"ServerGame: %@", (serverGame) ? @"Yes" : @"No");
    NSLog(@"==============================================");
     */
#endif
    
    molecules = [[NSMutableArray alloc] init];
    
    background = [[Image alloc] initWithImage:[level background] width:_width height:_height];
    
    pipeline = [[Image alloc] initWithImage:[level pipeline] width:_width height:_height];
    
    scoreboard = [[Image alloc] initWithImage:[level scoreboard] width:_width height:64];
    
    [_soundManager loadMusicWithKey:GAME_LOOP_KEY musicFile:[NSString stringWithFormat:@"%@.mp3", [level music]]];
    
    [hints removeAllObjects];
    
    totalMolecules = 0;
    totalMinicules = 0;
    totalCollisions = 0;
    sinkMissed = 0;
    sinkSuccess = 0;
    sinkFailure = 0;
    playerScore = 0;
    
    timer = [level duration];
    livesAllowed = [level lives];
    livesRemaining = [level lives];
    
    accuracy = 0.0f;
    
    duration = 0.0f;
    gameOver = NO;
    
    damageDelimiter = 1;
    activePowerUp = 0;
    powerupDuration = 0.0f;
    
    gameSpeed = DEFAULT_GAME_SPEED;
}

- (void)setup:(int)newStage withLevel:(int)newLevel {
    [self loadGameWithStage:newStage withLevel:newLevel fromServer:NO];
}

- (void)loadDailyChallenge {
    int useStage = -1;
    int useLevel = -1;
    
    @try {
        // Initiate the network request to the server for the game config.
        challenge = [_networkManager loadDailyChallenge:[_progressManager getProgressData]];
        
        useStage = [challenge stage];
        useLevel = [challenge level];
    }
    
    @catch ( NSException *e ) {
        
        // An exception occured connecting to the game server, use randoms for continuity.
        // The stage is limited to the first stage only, as they may not have open the others.
        //useStage = (int)[UIHelper randomNumberBetweenMinimum:1 andMaximum:STAGES_IN_GAME];
        useStage = (int)[UIHelper randomNumberBetweenMinimum:1 andMaximum:1];
        useLevel = (int)[UIHelper randomNumberBetweenMinimum:1 andMaximum:LEVELS_PER_STAGE];
    }
    
    @finally {
        [self loadGameWithStage:useStage withLevel:useLevel fromServer:YES];
    }

}

- (void)update:(float)delta {
    
    // Update the timer using the current frame rate (calculated in real-time).
    timer -= delta;
    if(timer < 0.0f) {
        timer = 0.0f;
    }

    // We need to record the duration that the game has currently been running for.
    duration += delta;

    // We need to update the state and position of every single molecule in the game
    // scene. Each molecule has it's own life cycle and properties of movement.
    for(int i=0; i < [level sinkholes].count; i++) {
        [(AbstractSinkhole*)[[level sinkholes] objectAtIndex:i] update:(delta * gameSpeed)];
    }
  
    // Initiate the spawn process, to determine if we should add another molecule
    // to the scene. It will need to be spawned from one of the existing spawnpods.
    [self spawn:(delta * gameSpeed)];

    // Perform the update with delta on all objects in our scene using the same
    // delta increment for each item. There should be an exact match on molecules
    // and sinkholes (as it's a single pairing between each of the atoms).
    for(int i=0; i < [molecules count]; i++) {
        AbstractMolecule *molecule = (AbstractMolecule*)[molecules objectAtIndex:i];

        // Check the clipping plane of the current molecule, determine rendering.
        [self clipping:molecule];
        
        // Perform collision detections for all the active molecules in system.
        [self collisions:molecule];
        
        // Check for movements and events from the players controller.
        [self movements:molecule];
        
        // Update the state of this molecule so it can adjust itself accordingly.
        [molecule update:(delta * gameSpeed)];
        
        // We have updated our molecules, so now we need to check for any dead
        // ones (ie. ones that have left the screen) for removal from the cache.
        if([molecule state] == kEntity_Dead) {
            [molecules removeObjectAtIndex:i];
        }
    }
        
    // Now update the state of all of the spawn pods, this is the final step.
    for(int i=0; i < [level spawnpods].count; i++) {
        [(SpawnPod*)[[level spawnpods] objectAtIndex:i] update:(delta * gameSpeed)];
    }
    
    // We need to add the hints system into here, ready for rendering.
    for(int i=0; i < hints.count; i++) {
        Hint *hint = (Hint*)[hints objectAtIndex:i];
        
        float x = [hint position].x;
        float y = [hint position].y + (delta * 50.0f);
        hint.timer -= (delta * 2.0f);
        hint.position = CGPointMake(x, y);
        
        if(hint.timer <= 0.0f) {
            [hints removeObjectAtIndex:i];
        }
    }
    
    // Maintain a record of the accuracy level of the current player.
    accuracy = ((100.0f / totalMolecules) * sinkSuccess);
    
    // We need to manage our powerups for the games bonus system.
    [self updatePowerUps:delta];

    // We need to check if the current game hs come to a natural end.
    if(((timer == 0) && (molecules.count == 0)) || (livesRemaining == 0)) {
        gameOver = YES;
    }
}

// This method creates a new molecule which is specifically designed for the pod that
// spawned it. The speed, direction and animation properties will be derived from the pod.
- (AbstractMolecule*)createMoleculeForPod:(AbstractSpawnpod*)spawnpod {
    
    float x = [spawnpod position].x;
    float y = [spawnpod position].y;
    int direction = [spawnpod direction];
    float speed = [spawnpod speed];
    
    AbstractMolecule *molecule = nil;
    Image *graphic = nil;
    
    int index = 1;
    
    if([spawnpod type] == SPAWNPOD_MOLECULE) {
        index = (RANDOM_0_TO_1() * [level sinkholes].count) + 1;
        
        NSString *targetImage = [NSString stringWithFormat:@"Molecule_%d", index];
        
        graphic = [[_imageManager getImageWithName:targetImage] retain];
        molecule = [[DraggableMolecule alloc] initWithImage:graphic atPoint:CGPointMake(x, y)];
        
    } else {
        index = (RANDOM_0_TO_1() * GAME_MINICULES) + 1;
        
        NSString *targetImage = [NSString stringWithFormat:@"Minicule_%d", index];
        
        graphic = [[_imageManager getImageWithName:targetImage] retain];
        molecule = [[TappableMolecule alloc] initWithImage:graphic atPoint:CGPointMake(x, y)];
    }
    
    [molecule setID:index];
    [molecule setState:kEntity_Alive];
    [molecule setDirection:direction];
    [molecule setInteraction:kInteraction_None];
    [molecule setSpeed:speed];

    Animation *animation = (Animation*)[[explosions objectAtIndex:(index-1)] copy];
    [animation setRunning:YES];
    [animation setRepeat:NO];

    [molecule setExplosion:animation];

    return [molecule autorelease];
}

- (void)spawn:(float)delta {
    
    // If our game timer has reached zero, do not even attempt a spawn.
    if(timer == 0.0f) {
        return;
    }
    
    // Loop through all the existing spawnpods, as we may spawn in parallel.
    for(int i=0; i < [[level spawnpods] count]; i++) {
        AbstractSpawnpod *spawnpod = (AbstractSpawnpod*)[[level spawnpods] objectAtIndex:i];

        // Determine if we are ready to spawn a new entity from the pods?
        if([spawnpod isReady]) {
        
            // Create a molecule template so we can check the conditions.
            AbstractMolecule *molecule = (AbstractMolecule*)[self createMoleculeForPod:spawnpod];
            
            // Check to see if it is safe to spawn a molecule at this point?
            if([self isSafeToSpawnMolecule:molecule]) {
            
                totalMolecules++;
                [molecule setUnique:totalMolecules];
                
                [molecules addObject:molecule];
                
                [spawnpod fire];
            }
        }
    }
}

// Check if the user has release the molecule they were dragging yet? In order
// to effectively guage the users movements, we need to check for drag/drop
// events from the controller - which setup certain flags on the game entity.
- (void)movements:(AbstractMolecule*)molecule {
    
    // We only need to deal with draggable objects for drag/drop. So for tappable
    // ones we need to check that they've not been double tapped for death?
    if([molecule isKindOfClass:[TappableMolecule class]]) {
        
        // If a double tap has occured, then mark the molecule for death.
        if([(TappableMolecule*)molecule isDoubleTapped] && !([molecule state] == kEntity_Dying)) {
            [self tapMolecule:molecule];
        }
        
        return;
    }
    
    // 1. Has the molecule been released?
    // 2. Was it dropped in a sinkhole, and if so the correct one?
    // 3. Has the entity been marked as dying?
    BOOL isMoleculeDropped = [molecule interaction] == kInteraction_Drop;
    BOOL isEntityTransitionNone = [molecule transition] == kTransition_None;
    BOOL isMoleculeNotDying = [molecule state] != kEntity_Dying;
    
    if(isMoleculeDropped && isEntityTransitionNone && isMoleculeNotDying) {
        
        BOOL inSinkhole = NO;
        BOOL inCorrectSinkhole = NO;
        
        AbstractSinkhole *sinkhole = nil;
        for(int i=0; i < [level sinkholes].count; i++) {
            sinkhole = (AbstractSinkhole*)[[level sinkholes] objectAtIndex:i];
            
            BOOL isDroppedInSinkhole = USE_PRECISION_DRAGGING ? CGRectContainsPoint([sinkhole bounds], [molecule position]) :
                    CGRectIntersectsRect([molecule bounds], [sinkhole bounds]);
             
            if(isDroppedInSinkhole) {
                inSinkhole = YES;
                inCorrectSinkhole = ([molecule ID] == [sinkhole ID]);
             
                break;
            }
        }
        
        if(inSinkhole) {
            if(inCorrectSinkhole) {
                [self dropMolecule:molecule inSinkhole:sinkhole];
            } else {
                [self dropMolecule:molecule];
            }
        } else {
            [self dropMolecule:molecule];
        }
    }
}

- (void)dropMolecule:(AbstractMolecule*)molecule inSinkhole:(AbstractSinkhole*)sinkhole {
    [molecule setPosition:[sinkhole position]];
    
    [molecule setState:kEntity_Idle];
    [molecule setTransition:kTransition_Success];

    [sinkhole boom];
    
    sinkSuccess++;
    
    [_soundManager playSoundWithKey:DROP_SUCCESS_KEY];

    [self updateScore:molecule];
}

- (void)dropMolecule:(AbstractMolecule*)molecule {
    [molecule setTransition:kTransition_Failure];
    [molecule explode];

    livesRemaining--;
    sinkFailure++;
    
    if(livesRemaining == 1) {
        [_soundManager playSoundWithKey:FINAL_LIFE_KEY];
    } else {
        [_soundManager playSoundWithKey:DROP_FAILURE_KEY];
    }
}

- (void)missMolecule:(AbstractMolecule*)molecule {
    [molecule setState:kEntity_Dead];
    sinkMissed++;
}

- (void)tapMolecule:(AbstractMolecule*)molecule {
    [molecule explode];
    sinkSuccess++;
    
    [self updateBonus:molecule];
}

- (void)killMolecule:(AbstractMolecule*)molecule {
    [molecule explode];
    sinkSuccess++;
    
    [self updateScore:molecule];
}

// This method takes the edges of each molecule, and tries to determine if the
// entity has reached the device screen boundary. Set the state to dead if true.
- (void)clipping:(AbstractMolecule*)molecule {
    float left = [molecule position].x - ([[molecule graphic] imageWidth] / 2.0f);
    float right = [molecule position].x + ([[molecule graphic] imageWidth] / 2.0f); 
    float top = [molecule position].y + ([[molecule graphic] imageHeight] / 2.0f);
    float bottom = [molecule position].y - ([[molecule graphic] imageHeight] / 2.0f);
    
    if((left > _width) || (right < 0.0f) || (bottom > _height) || (top < 0.0f)) {
        [self missMolecule:molecule];
    }
}

- (void)openNextSteamPodOnCollision {
    for(int i=0; i < [[level spawnpods] count]; i++) {
        AbstractSpawnpod *spawnpod = (AbstractSpawnpod*)[[level spawnpods] objectAtIndex:i];
        if([spawnpod isKindOfClass:[SteamPod class]] && (spawnpod.state == kEntity_Idle)) {
            [spawnpod open];
            break;
        }
    }
}

// This is our main collision detection algorithm, as we need to make sure that all
// of the moving molecules (that are not being dragged) are checked for collisions.
- (void)collisions:(AbstractMolecule*)molecule {
    for(int i=0; i < [molecules count]; i++) {
        AbstractMolecule *collider = (AbstractMolecule*)[molecules objectAtIndex:i];
        if([molecule unique] != [collider unique]) {
            if([molecule state] == kEntity_Alive || [molecule state] == kEntity_Idle) {
                if([collider state] == kEntity_Alive || [collider state] == kEntity_Idle) {
                    if([molecule interaction] == kInteraction_None && [collider interaction] == kInteraction_None) {
                        if([self intersect:molecule with:collider]) {
                            
                            [molecule explode];
                            [collider explode];
                            
                            [_soundManager playSoundWithKey:COLLISION_KEY];
                            
                            totalCollisions++;
                            sinkMissed += 2;
                            
                            [self openNextSteamPodOnCollision];
                        }
                    }
                }
            }
        }
    }
}

// This method checks the standard spherical collisions between two molecules
// using the bounding spheres calculation. It needs some optimizition later on.
// devmag.org.za/2009/04/13/basic-collision-detection-in-2d-part-1/
- (BOOL)intersect:(AbstractMolecule*)a with:(AbstractMolecule*)b {
    float ra = [a radius];  // Radius (A)
    float rb = [b radius];  // Radius (B)
    
    float dx = ([b position].x - [a position].x);
    float dy = ([b position].y - [a position].y);
    
    // Get distance using pythagorus.
    float dist = (dx*dx) + (dy*dy);
    
    return dist <= (ra + rb) * (ra + rb);
}

// An action has been performed with the molecule, so we need to perform a score
// update depending on the kind of molecule that has been processed in the scene.
- (void)updateProgress:(AbstractMolecule*)molecule {
    if([molecule isKindOfClass:[TappableMolecule class]]) {
        [self updateBonus:molecule];
    } else {
        [self updateScore:molecule];
    }
}

- (void)updateBonus:(AbstractMolecule *)molecule {
    switch([molecule ID]) {
        case 1 : [self slowMotion:molecule]; break;
        case 2 : [self timeBonus:molecule]; break;
        case 3 : [self doubleDamage:molecule]; break;
        case 4 : [self quadDamage:molecule]; break;
        case 5 : [self destruction:molecule]; break;
        default: break;
    }
}

- (void)updateScore:(AbstractMolecule *)molecule {
    int score = 0;
    switch([molecule ID]) {
        case 1 : score = 1000; break;
        case 2 : score = 2000; break;
        case 3 : score = 3000; break;
        case 4 : score = 4000; break;
        case 5 : score = 5000; break;
        default: break;
    }
    
    score *= damageDelimiter;
    playerScore += score;
    
    Hint *hint = [[Hint alloc] init];
    [hint setText:[NSString stringWithFormat:@"%d pts", score]];
    [hint setPosition:[molecule position]];
    [hint setTimer:HINTS_TIMER_DURATION];
    
    [hints addObject:hint];
    
    [hint release];
}

// We need to check that each molecule we spawn does not immediately collide with another
// molecule that we created only a few moments ago. We need to ignore the spawn request.
- (BOOL)isSafeToSpawnMolecule:(AbstractMolecule*)molecule {
    for(int i=0; i < molecules.count; i++) {
        AbstractMolecule *existing = (AbstractMolecule*)[molecules objectAtIndex:i];
        if([self intersect:molecule with:existing]) {
            return NO;
        }
    }
    return YES;
}

// This is a standard accessor method, which can inform calling classes whether
// the game has come to a natural end. Usually called by the scene managers.
- (BOOL)isGameOver {
    return gameOver;
}

- (BOOL)isServerGame {
    return serverGame;
}

- (BOOL)isActivePowerUp {
    return (activePowerUp != 0);
}

// TODO: We need to ascertain the retina display type!
- (PlayerScore*)getScore {
    PlayerScore *score = [[PlayerScore alloc] init];
    [score setWidth:_width];
    [score setHeight:_height];
    [score setRetina:YES];
    [score setStage:currentStage];
    [score setLevel:currentLevel];
    [score setMolecules:totalMolecules];
    [score setSuccess:sinkSuccess];
    [score setFailure:sinkFailure];
    [score setMissed:sinkMissed];
    [score setCollisions:totalCollisions];
    [score setDuration:duration];
    [score setScore:playerScore];
    [score setTarget:[level target]];
    [score setPercentage:accuracy];
    [score setLivesAllowed:livesAllowed];
    [score setLivesRemaining:livesRemaining];
    [score setProgress:[self calculatePlayerProgress]];
    
    return [score autorelease];
}

- (Level*)getLevel {
    return level;
}

- (DailyChallenge*)getChallenge {
    return challenge;
}

- (int)calculatePlayerProgress {
    int state = 0;
    if((accuracy == 100.0f) && (livesRemaining == livesAllowed) && (sinkSuccess == totalMolecules) && (sinkMissed == 0) && (totalCollisions == 0)) {
        // Level Passed (Above or Equal to target, lives remaining)
        state = 5;
        
    } else if((accuracy > level.target) && (livesRemaining == livesAllowed) && (totalCollisions == 0)) {
        // Level Passed (Above target, full lives remaining, no collisions)
        state = 4;
        
    } else if((accuracy >= level.target) && (livesRemaining == livesAllowed)) {
        // Level Passed (Above target, full lives remaining)
        state = 3;
        
    } else if((accuracy >= level.target) && (livesRemaining > 0)) {
        // Level Passed (Above target, lives remaining)
        state = 2;
        
    } else {
        // Level Failed.
        state = 1;
    }
    
    return state;
}

- (void)updatePowerUps:(float)delta {
    if((powerupDuration > 0.0f) && (activePowerUp > 0)) {
        powerupDuration -= delta;
    }
    
    if(powerupDuration < 0.0f) {
        powerupDuration = 0.0f;
        
        activePowerUp = 0;
        damageDelimiter = 1;
        
        gameSpeed = DEFAULT_GAME_SPEED;
    }
}

- (void)slowMotion:(AbstractMolecule*)molecule {
    activePowerUp = 1;
    damageDelimiter = 1;
    
    [_soundManager playSoundWithKey:SPEED_BOOST_KEY];
    
    gameSpeed = POWERUP_GAME_SPEED;
    
    powerupDuration = POWERUP_DURATION;
}

- (void)timeBonus:(AbstractMolecule*)molecule {
    activePowerUp = 2;
    damageDelimiter = 1;

    [_soundManager playSoundWithKey:TIME_BONUS_KEY];

    timer += 10.0f;
    
    powerupDuration = 2.0f;
}

- (void)doubleDamage:(AbstractMolecule*)molecule {
    activePowerUp = 3;
    damageDelimiter = 2;
    
    [_soundManager playSoundWithKey:DOUBLE_DAMAGE_KEY];
    
    powerupDuration = POWERUP_DURATION;
}

- (void)quadDamage:(AbstractMolecule*)molecule {
    activePowerUp = 4;
    damageDelimiter = 4;
    
    [_soundManager playSoundWithKey:QUAD_DAMAGE_KEY];
    
    powerupDuration = POWERUP_DURATION;
}

- (void)destruction:(AbstractMolecule*)molecule {
    activePowerUp = 5;
    damageDelimiter = 1;
    
    [_soundManager playSoundWithKey:TOTAL_DESTRUCTION_KEY];
    
    for(int i=0; i < molecules.count; i++) {
        AbstractMolecule *molecule = (AbstractMolecule*)[molecules objectAtIndex:i];
        if(molecule.state == kEntity_Alive) {
            [self killMolecule:molecule];
        }
    }
    
    powerupDuration = 2.0f;
}

// Each level tears down it's own memory when it finishes, and then re-allocates
// it when the new level is loaded. So we need to call the teardown function first.
- (void)dealloc {    
	[super dealloc];
    [molecules release];
    [explosions release];
    [level release];
    
    [background release];
    [scoreboard release];
    [pipeline release];
}

@end
