//
//  Constants.h
//  Atomik
//
//  Created by James on 12/1/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#ifndef Atomik_Constants_h
#define Atomik_Constants_h

// Define the Atomik Keys
#define GAME_DEVELOPER              @"Black Cell"
#define GAME_PROGRAMMER             @"James Lee Bishop"
#define GAME_AUDIO                  @"Various Artists"
#define GAME_VERSION                @"1.0.1"
#define GAME_UPDATED                @"15th October 2015"

#define APPLE_ID_FULL               @"813507106"
#define APPLE_ID_LITE               @""

// Define the Config Keys
#define RESOURCE_CONFIG_FILE        @"Resource_Config"
#define MENU_CONFIG_FILE            @"Menu_Config"
#define STAGE_CONFIG_FILE           @"Stage_Config"
#define GAME_CONFIG_FILE            @"Game_Config"
#define PURCHASE_CONFIG_FILE        @"Purchase_Config"

// Define the Scene Keys
#define LOGO_SCENE_KEY              @"logo"
#define MENU_SCENE_KEY              @"menu"
#define AUDIO_SCENE_KEY             @"audio"
#define RULES_SCENE_KEY             @"rules"
#define STAGE_SCENE_KEY             @"stage"
#define DAILY_SCENE_KEY             @"daily"
#define GAME_SCENE_KEY              @"game"
#define SCORE_SCENE_KEY             @"score"
#define CREDITS_SCENE_KEY           @"credits"
#define PURCHASE_SCENE_KEY          @"purchase"
#define FINISH_SCENE_KEY            @"finish"

// Define the Button Keys
#define BACK_BUTTON_KEY             @"Button_Back"
#define HOME_BUTTON_KEY             @"Button_Home"
#define MENU_BUTTON_KEY             @"Button_Menu"
#define PLAY_BUTTON_KEY             @"Button_Play"
#define NEXT_BUTTON_KEY             @"Button_Next"
#define SAVE_BUTTON_KEY             @"Button_Save"

#define BUTTON_INACTIVE             0
#define BUTTON_ACTIVE               1

// Define the Audio Keys
#define BLAST_AUDIO_KEY             @"blastdoor"
#define LOGO_LOOP_KEY               @"logoloop"
#define MENU_LOOP_KEY               @"menuloop"
#define AUDIO_LOOP_KEY              @"audioloop"
#define STAGE_LOOP_KEY              @"stageloop"
#define DAILY_LOOP_KEY              @"dailyloop"
#define GAME_LOOP_KEY               @"gameloop"
#define SCORE_LOOP_KEY              @"scoreloop"
#define CREDITS_LOOP_KEY            @"creditsloop"
#define RULES_LOOP_KEY              @"rulesloop"
#define PURCHASE_LOOP_KEY           @"purchaseloop"
#define FINISH_LOOP_KEY             @"finishloop"

#define MENU_SELECT_KEY             @"menuselect"
#define MENU_BACK_KEY               @"menuback"
#define COLLISION_KEY               @"collision"

// Define the Image Keys
#define UPPER_DOOR_KEY              @"Upper_Door"
#define LOWER_DOOR_KEY              @"Lower_Door"

// Define the Bonus Keys
#define SPEED_BOOST_KEY             @"Speed_Boost"
#define TIME_BONUS_KEY              @"Time_Bonus"
#define DOUBLE_DAMAGE_KEY           @"Double_Damage"
#define QUAD_DAMAGE_KEY             @"Quad_Damage"
#define TOTAL_DESTRUCTION_KEY       @"Total_Destruction"

#define TIME_EXPIRED_KEY            @"Time_Expired"
#define FINAL_LIFE_KEY              @"Final_Life"

#define DROP_SUCCESS_KEY            @"Drop_Success"
#define DROP_FAILURE_KEY            @"Drop_Failure"

// Define the Game Constants
#define USE_PRECISION_DRAGGING      NO

#define DEFAULT_SPAWNPOD_DELAY      3.0f
#define DEFAULT_SPAWNPOD_DELTA      2.0f
#define DEFAULT_SPAWNPOD_SPEED      1.0f

#define DEFAULT_STEAMPOD_DELAY      15.0f
#define DEFAULT_STEAMPOD_DELTA      2.0f
#define DEFAULT_STEAMPOD_SPEED      10.0f

#define DEFAULT_GAME_SPEED          1.0f
#define POWERUP_GAME_SPEED          0.5f
#define POWERUP_DURATION            5.0f

#define GAME_MOLECULES              5
#define GAME_MINICULES              5
#define GAME_SINKHOLES              5

#ifdef LITE_VERSION
    #define STAGES_IN_GAME          1
#else
    #define STAGES_IN_GAME          3
#endif

#define LEVELS_PER_STAGE            9
#define TOTAL_ICON_STATES           5
#define LEVEL_UNLOCKED              1

#define STEAMPOD_TAPS               1

// Define the Graphics Constants
#define PARTICLE_EMITTER_ROUND      @"particle-round"
#define PARTICLE_EMITTER_SPOTLITE   @"particle-spotlite"
#define PARTICLE_EMITTER_STAR       @"particle-star"
#define PARTICLE_EMITTER_SNOWFLAKE  @"particle-snowflake"

#define HINTS_TIMER_DURATION        1.0f

// Define the Audio FX Constants
#define DEFAULT_MUSIC_VOLUME        0.30f
#define DEFAULT_EFFECTS_VOLUME      1.00f

#endif
