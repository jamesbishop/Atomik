//
//  GameManager.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "SoundManager.h"
#import "ImageManager.h"
#import "LevelManager.h"
#import "NetworkManager.h"
#import "ProgressManager.h"
#import "Level.h"
#import "Image.h"
#import "Hint.h"
#import "SpriteSheet.h"
#import "Device.h"
#import "Common.h"
#import "PlayerScore.h"
#import "DailyChallenge.h"
#import "UIHelper.h"

#import "AbstractEntity.h"
#import "AbstractMolecule.h"
#import "AbstractSinkhole.h"
#import "SpawnPod.h"
#import "SteamPod.h"
#import "DraggableMolecule.h"
#import "TappableMolecule.h"
#import "BasicSinkhole.h"

@interface GameManager : NSObject {
	SoundManager *_soundManager;        // Sound Manager
    ImageManager *_imageManager;        // Image Manager
    ProgressManager *_progressManager;  // Progress Manager
    NetworkManager *_networkManager;    // Network Manager
    
    NSMutableArray *molecules;          // Molecules
    NSMutableArray *explosions;         // Explosions
    NSMutableArray *hints;              // Game hints
    NSMutableArray *powerups;           // Power Ups
    
    Level *level;                       // Current Level
    
    Image *background;
    Image *scoreboard;
    Image *pipeline;
    DailyChallenge *challenge;
    
    int currentStage;
    int currentLevel;
    int totalCollisions;
    int totalMolecules;
    int totalMinicules;
    int sinkSuccess;
    int sinkFailure;
    int sinkMissed;
    
    int playerScore;
    int livesAllowed;
    int livesRemaining;
    
    float accuracy;
    
    float timer;
    float duration;
    BOOL serverGame;
    BOOL gameOver;
    
    int damageDelimiter;
    int activePowerUp;
    
    float powerupDuration;
    
    int _width;
    int _height;
    int _centreX;
    int _centreY;
    
    float gameSpeed;
}

@property (nonatomic, retain) NSMutableArray *molecules;
@property (nonatomic, retain) NSMutableArray *hints;
@property (nonatomic, retain) NSMutableArray *powerups;
@property (nonatomic, retain) Level *level;
@property (nonatomic, retain) Image *background;
@property (nonatomic, retain) Image *scoreboard;
@property (nonatomic, retain) Image *pipeline;
@property (nonatomic, assign) int livesAllowed;
@property (nonatomic, assign) int livesRemaining;
@property (nonatomic, assign) int activePowerUp;
@property (nonatomic) float timer;

+ (id)sharedGameManager;

- (void)setup:(int)stage withLevel:(int)level;
- (void)loadDailyChallenge;

- (void)update:(float)delta;

- (BOOL)isGameOver;
- (BOOL)isServerGame;
- (BOOL)isActivePowerUp;

- (PlayerScore*)getScore;
- (Level*)getLevel;
- (DailyChallenge*)getChallenge;

@end
