//
//  BuddhaViewController.h
//  Buddha
//
//  Created by Joe on 12/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
	S0,
	S1,
	S2
} TOUCHSTATE;


@interface BuddhaViewController : UIViewController {

	UIImageView *buddha;
	UIImageView *backg;
	UIImageView *buddha_tell;
	UIImageView *mmbackg;

	NSArray *tellingBuddhas;
	NSArray *buddha_says;
	
	IBOutlet UIView *tellView;
	IBOutlet UITextView *tellViewText;
	
	CGPoint startLocation, endLocation;
	NSTimeInterval startTime, endTime;
	TOUCHSTATE			state;
	
	NSTimer *bounceTimer;
	BOOL bounceAnimActive;
	BOOL jumpAnimActive;
	BOOL jumpUpAndDown;
	BOOL jumpUpAndDownStop;
	
	int buddhaJumps;
	long touchesOnBuddha;
	long touchesOnBuddhaBelly;
	
	float buddhaScale;
	float buddhaAScale;

}

- (void) animationRotate: (float) duration;

- (void) animationBounceByScale: (int) ydelta duration:(CGFloat ) dura timing: (NSString *) timingF;

- (void) animationJumpUp: (CGFloat) high duration: (CGFloat) dura;

- (void) buddhaAnimJumpUpAndDown: (CGFloat) duration;


@end

