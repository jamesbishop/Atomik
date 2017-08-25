//
//  Common.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <OpenGLES/ES1/gl.h>
#import <mach/mach.h>
#import <mach/mach_time.h>

#pragma mark -
#pragma mark Macros

// Define our target platform frame rate for the game.
#define FRAME_RATE      60.0f

// Define the speed at which we expect our game to run.
#define FRAME_DELTA		(1.0f / FRAME_RATE)

// Macro which returns a random value between -1 and 1
#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff )-1.0f)

// Macro which returns a random number between 0 and 1
//#define RANDOM_0_TO_1() ((random() / (GLfloat)0x7fffffff ))
#define RANDOM_0_TO_1() ((double)arc4random() / 0x100000000)

// Macro which converts degrees into radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * M_PI / 180.0)

// Macro which converts degrees into radians
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 180.0 / M_PI)

// Tell our graphics engine whether we want to use retina.
#define USE_RETINA_DISPLAY      YES

// Show whether we want to display the current frame rate.
#define DISPLAY_FRAME_RATE      NO

#pragma mark -
#pragma mark Enumerations

enum {
	kSceneState_Idle,
	kSceneState_TransitionIn,
	kSceneState_TransitionOut,
	kSceneState_Running,
	kSceneState_Paused
};

#pragma mark -
#pragma mark Types

typedef struct _TileVert {
	GLfloat v[2];
	GLfloat uv[2];
} TileVert;

typedef struct _Color4f {
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color4f;

typedef struct _Vector2f {
	GLfloat x;
	GLfloat y;
} Vector2f;

typedef struct _Quad2f {
	GLfloat bl_x, bl_y;
	GLfloat br_x, br_y;
	GLfloat tl_x, tl_y;
	GLfloat tr_x, tr_y;
} Quad2f;

typedef struct _Particle {
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
	GLfloat particleSize;
	GLfloat timeToLive;
} Particle;

typedef struct _PointSprite {
	GLfloat x;
	GLfloat y;
	GLfloat size;
} PointSprite;

#pragma mark -
#pragma mark Inline Functions

static const Color4f Color4fInit = {1.0f, 1.0f, 1.0f, 1.0f};

static const Vector2f Vector2fZero = {0.0f, 0.0f};

static inline Vector2f Vector2fMake(GLfloat x, GLfloat y) {
	return (Vector2f) {x, y};
}

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha) {
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, GLfloat s) {
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2) {
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2) {
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}

static inline GLfloat Vector2fDot(Vector2f v1, Vector2f v2) {
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}

static inline GLfloat Vector2fLength(Vector2f v) {
	return (GLfloat) sqrtf(Vector2fDot(v, v));
}

static inline Vector2f Vector2fNormalize(Vector2f v) {
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}

