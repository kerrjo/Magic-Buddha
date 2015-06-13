//
//  BuddhaViewController.m
//  Buddha
//
//  Created by Joe on 12/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BuddhaViewController.h"


@interface BuddhaViewController()
- (void) placeBuddha;
- (void) buddhaTell;
- (void) startEnvironment;
- (void) buddhaAnimBounce;
- (void) buddhaAnimJump;
- (void) becomeActive;

@end



@implementation BuddhaViewController

- (void)viewDidLoad {
  [super viewDidLoad];
	[self.view setBackgroundColor: [UIColor lightGrayColor]];
	
  buddha = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sittingbuddha"]];
	
	tellingBuddhas=[[NSArray alloc]  initWithObjects:
                  @"buddhasideface320x340alpha.png",
                  @"buddhacloseuplauph320x480.png",
                  @"buddhacloseup320x480.png",
                  nil];
  
	buddha_says=[[NSArray alloc]  initWithObjects:
               @"Resist evil",
               @"Where's my monkey?",
               @"Rub my belly",
               @"Look within",
               @"Change your question",
               @"Follow your heart",
               @"Fill your mind with compassion",
               @"What we think, we become.",
               @"The greatest patience is humility",
               @"Grasp at nothing",
               @"You are not ready",
               @"Bend with the wind",
               @"Search your feelings",
               nil];
	
	bounceTimer=nil;
	bounceAnimActive=NO;
	jumpAnimActive=NO;
	touchesOnBuddha=0;
	touchesOnBuddhaBelly=0;
	buddhaScale=.85;
	buddhaAScale=1.0;
	state=S0;
	
	[self placeBuddha];
	
	buddha_tell = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buddhasideface320x340alpha.png"]];
	buddha_tell.userInteractionEnabled=YES;
	backg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lotusf03320x480_2.png"]];;
	mmbackg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lotuscircblue500alpha.png"]];;
	mmbackg.center=self.view.center;
	mmbackg.layer.opacity=0.6f;
  
	[self startEnvironment];
	
	[self.view addSubview:buddha];
  
  [[NSNotificationCenter defaultCenter] 
	 addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

}


- (void) becomeActive{
  NSLog(@"%s",__FUNCTION__);
  
  [self animationRotate:100];
}
- (void)viewDidDisapper:(BOOL)animated {

  [[NSNotificationCenter defaultCenter] removeObserver:self];
 }

- (void) startEnvironment{
	int env=1;
	
	if (env==1) { // enviro 1 spinning
		mmbackg.transform = CGAffineTransformMakeScale(1.4, 1.4);
    
		[self animationRotate:100];
		
    [self.view addSubview:mmbackg];
		
	} else if (env==2){
    
		[self.view addSubview:backg];
	}
	
}


- (void) placeBuddha {
	int env=1;
	
	CGPoint p = self.view.center;
	buddha.userInteractionEnabled=YES;
	buddha.transform = CGAffineTransformMakeScale(buddhaScale, buddhaScale);
	if (env==1){
	}else if (env==2){
		p.y = self.view.frame.size.height - buddha.frame.size.height/2 - 40;
	}
	buddha.center=p;
}


- (void) buddhaTell {
	int env=1;
	
	int n = (random() % [tellingBuddhas count]);
	UIImage *image=[UIImage imageNamed:[tellingBuddhas objectAtIndex:n]];
	CGRect r= buddha_tell.frame;
	r.size.width=image.size.width;
	r.size.height=image.size.height;
	buddha_tell.frame=r;
	buddha_tell.image = image;
  
	int rnd = (random() % [buddha_says count]);
	tellViewText.text=[buddha_says objectAtIndex:rnd];
	
	tellViewText.font = [UIFont  systemFontOfSize:28];
	CGPoint p = self.view.center;
	p.y = self.view.frame.size.height - tellView.frame.size.height/2;
	tellView.center=p;
	
	[buddha removeFromSuperview];
	
	if (env==1){
		
	}else if (env==2){
		[backg removeFromSuperview];
	}	
	
	[self.view addSubview:buddha_tell];
	[self.view addSubview:tellView];
  
}


- (void) buddhaReady {
  
	int env=1;
  
	[buddha_tell removeFromSuperview];
	[tellView removeFromSuperview];
	
	if (env==1) 
  { // enviro 1 spinning
		
	} 
  else if (env==2)
  {
    [self.view addSubview:backg];
  }
  
  
	[self.view addSubview:buddha];
  
}


// ANIMATION



#pragma mark check swipes and touches

- (void)checkSwipe {
  
	NSString  *message;
	if(state==S0){
		// swipe occurring
		//[@"\t\t\t\t\t\t\t\t\t\t" drawAtPoint:CGPointMake(10,100) withFont:[UIFont systemFontOfSize:16]];
	}
	if(state == S1){
		message = 
		[NSString 
		 stringWithFormat:@"Took %4.3f seconds", endTime-startTime
		 ];
		NSLog(@"%@",message);
		message = 
		[NSString 
		 stringWithFormat:@"Number of touches buddha %ld  %4.3f pts/s", touchesOnBuddha,
		 (endTime-startTime) > 0 ? fabs(touchesOnBuddha) /(endTime-startTime) : 0
		 ];
		NSLog(@"%@",message);
		message = 
		[NSString 
		 stringWithFormat:@"Number of touches buddha belly %ld  %4.3f pts/s", touchesOnBuddhaBelly,
		 (endTime-startTime) > 0 ? fabs(touchesOnBuddhaBelly) /(endTime-startTime) : 0
		 ];
		NSLog(@"%@",message);
		state = S0;
	}
  
}


// TOUCHES
//		if (CGRectContainsPoint (gameContainerView.handleRect,p)){

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	int noTouchesInEvent  = ((NSSet*)[event allTouches]).count;
	int noTouchesBegan	  = touches.count;
	UITouch *touch = [touches anyObject];
  
	if ([touch view] == buddha){
		NSLog(@"began %i, total %i", noTouchesBegan, noTouchesInEvent);
		if((state == S0) && (noTouchesBegan== 1) && (noTouchesInEvent==1)){
			startLocation  = [(UITouch*)[touches anyObject] locationInView:buddha];
			startTime	   = [(UITouch*)[touches anyObject] timestamp];
			state = S1;
			touchesOnBuddha=0;
			touchesOnBuddhaBelly=0;
			buddhaJumps=0;
			[buddha.layer removeAnimationForKey:@"bouncebyscale" ];
		}
		else{
			state = S0;
			//[self.view setNeedsDisplay];
			[self checkSwipe];
		}
	}
	
	if ([touch view] == buddha){
		//[self buddhaAnimJumpUpAndDown: 2.0];
		//[self animationJumpUp: 100.0 duration: 0.3];
		//[self buddhaAnimBounce];
		//[self buddhaTell];
	}
	if ([touch view] == buddha_tell){
		[self buddhaReady];
	} else
    if ([touch view] == tellView){
      [self buddhaReady];
    }
	
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  
	int noTouchesInEvent  = ((NSSet*)[event allTouches]).count;
	int noTouchesEnded	  = touches.count;
	NSLog(@"ended %i %i", touches.count, ((NSSet*)[event allTouches]).count);
	if( (state==S1) && (noTouchesEnded == 1) && (noTouchesInEvent==1)){
		endLocation = [(UITouch*)[touches anyObject] locationInView:buddha];
		endTime		= [(UITouch*)[touches anyObject] timestamp];
		[self checkSwipe];
	}
  
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	//NSLog (@"object %@ touch  %@",self,[touch view]);	
	if ([touch view] == buddha){
		//CGPoint p = [touch locationInView:buddha];
		touchesOnBuddha++;
		touchesOnBuddhaBelly++;
		if (touchesOnBuddhaBelly > 50){
			NSTimeInterval eTime = [(UITouch*)[touches anyObject] timestamp];
			float persec= (eTime-startTime) > 0 ? fabs(touchesOnBuddhaBelly) /(eTime-startTime) : 0;
			if (persec > 38.0){
				[self  buddhaAnimBounce];
				NSLog (@"touches %ld  jumps %d ",touchesOnBuddhaBelly,buddhaJumps);
				if (touchesOnBuddhaBelly > 110){
					[self buddhaAnimJumpUpAndDown: 2.0];
				} else if (touchesOnBuddhaBelly > 75){
					if (buddhaJumps > 2){
						[self buddhaAnimJumpUpAndDown: 1.5];
					}
					else {
						[self buddhaAnimJump];
					}
				}
			}
		}
		//	if (CGRectContainsPoint (gameContainerView.handleRect,p)){
	}
}







// Motion
- (BOOL)canBecomeFirstResponder {return YES;}

- (void)viewDidAppear:(BOOL)animated {[self becomeFirstResponder];}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	
  //if ([buddha superview])
  
  [self buddhaTell];

	//else 
	//	[self buddhaReady];
	
}


- (void) buddhaBounceReturn: (NSTimer *) timer {
  
	NSLog(@"Bounce timer popped");
	
  [buddha.layer removeAnimationForKey:@"bouncebyscale" ];
	
  bounceAnimActive=NO;
	if (bounceTimer!=nil)
  {  // if called not by the timer
		[bounceTimer invalidate];
		bounceTimer=nil;
	}
  
	buddha.transform = CGAffineTransformMakeScale(buddhaScale, buddhaScale);
  
}


- (void) buddhaAnimBounce {
	
  if (!bounceAnimActive)
  {
		[self animationBounceByScale:0 duration:0.08 timing: kCAMediaTimingFunctionEaseIn];
		bounceAnimActive=YES;
		bounceTimer= [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(buddhaBounceReturn:) userInfo:nil repeats:NO] ;
		[[NSRunLoop mainRunLoop] addTimer:bounceTimer forMode:NSDefaultRunLoopMode];
	}
}



- (void) buddhaAnimJump {
	if (!jumpAnimActive){
		jumpUpAndDown=NO;
		buddhaJumps++;
		[self animationJumpUp: 130.0 duration: 0.4];
		jumpAnimActive=YES;
	}
}

- (void) buddhaAnimJumpUpAndDownReturn: (NSTimer *) timer {
	NSLog(@"JumpUpAndDown timer popped");
	jumpUpAndDownStop=YES;
	CAAnimation *a=[buddha.layer animationForKey:@"jumpupmove" ];
	if (a==nil){
		// not finished
		NSLog (@"animation has finished");
		jumpAnimActive=NO;
		buddha.transform = CGAffineTransformMakeScale(buddhaScale, buddhaScale);
		buddha.center = self.view.center;
	} else {
		NSLog (@"animation has not finished");
		// wait for it to finish
		NSTimer *jumpTimer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(buddhaAnimJumpUpAndDownReturn:) userInfo:nil repeats:NO] ;
		[[NSRunLoop mainRunLoop] addTimer:jumpTimer forMode:NSDefaultRunLoopMode];
	}
}

- (void) buddhaAnimJumpUpAndDown: (CGFloat) duration {
	if (jumpAnimActive){
		
		[buddha.layer removeAnimationForKey:@"jumpupmove" ];
		[buddha.layer removeAnimationForKey:@"jumpupscale" ];
	}
	jumpUpAndDownStop=NO;
	jumpUpAndDown=YES;
	jumpAnimActive=YES;
	[self animationJumpUp: 115.0 duration: 0.3];
	NSTimer *jumpTimer= [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(buddhaAnimJumpUpAndDownReturn:) userInfo:nil repeats:NO] ;
	[[NSRunLoop mainRunLoop] addTimer:jumpTimer forMode:NSDefaultRunLoopMode];
}



- (void) animationBounceByFrame: (int) ydelta duration:(CGFloat ) dura rect1: (CGRect) r1 rect2: (CGRect) r2 timing: (NSString *) timingF{
	CGFloat timeToAnimate = 0.2;
	timeToAnimate=dura;
	NSLog (@"Bounce  from  %f  to %f   duration %f ",r1.origin.y,r2.origin.y,dura);
	CALayer *vLayer = buddha.layer;
	CABasicAnimation *bounce; 
	bounce = [CABasicAnimation animationWithKeyPath:@"bounds"]; 
	bounce.fromValue = [NSValue valueWithCGRect:r1]; 
	bounce.toValue = [NSValue valueWithCGRect:r2];
	bounce.repeatCount =1; 
	bounce.delegate=self;
	bounce.autoreverses=YES;
	bounce.removedOnCompletion=YES;
	[bounce setValue:@"bouncebyframe" forKey:@"name"];
	bounce.timingFunction = [CAMediaTimingFunction functionWithName:timingF];
	//	kCAMediaTimingFunctionEaseIn kCAMediaTimingFunctionDefault kCAMediaTimingFunctionLinear
	bounce.duration = timeToAnimate;
	[vLayer addAnimation:bounce forKey:@"bouncebyframe"];
}

- (void) animationBounceByScale: (int) ydelta duration:(CGFloat ) dura timing: (NSString *) timingF{
	CGFloat timeToAnimate = 0.2;
	timeToAnimate=dura;
	//NSLog (@"Bounce  from  %f  to %f   duration %f ",r1.origin.y,r2.origin.y,dura);
	CALayer *vLayer = buddha.layer;
	CABasicAnimation *bounce; 
	bounce = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"]; 
	bounce.fromValue = [NSNumber numberWithFloat:buddhaScale]; 
	bounce.toValue = [NSNumber numberWithFloat:buddhaScale-.05]; 
	bounce.duration = dura; 
	bounce.repeatCount = 0; 
	bounce.delegate=self;
	bounce.autoreverses=YES;
	bounce.removedOnCompletion=YES;
	[bounce setValue:@"bouncebyscale" forKey:@"name"];
	bounce.timingFunction = [CAMediaTimingFunction functionWithName:timingF];
	//	kCAMediaTimingFunctionEaseIn kCAMediaTimingFunctionDefault kCAMediaTimingFunctionLinear
	bounce.duration = timeToAnimate;
	[vLayer addAnimation:bounce forKey:@"bouncebyscale"];
}

- (void) animationJumpUp: (CGFloat) high duration: (CGFloat) dura {
	
	CGFloat timeToAnimate = 0.2;
	timeToAnimate = dura;
	CALayer *vLayer = buddha.layer;
	CABasicAnimation *scale; 
	scale = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"]; 
	scale.fromValue = [NSNumber numberWithFloat:buddhaScale]; 
	scale.toValue = [NSNumber numberWithFloat:buddhaScale + 0.1]; 
	scale.repeatCount = 0; 
	scale.delegate=self;
	scale.autoreverses=NO;
	scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[scale setValue:@"jumpupscale" forKey:@"name"];
	// Create the animation's path.
	CAKeyframeAnimation *alongPath = [CAKeyframeAnimation animationWithKeyPath: @"position"];
  
	CGPoint startPoint=buddha.center;
	CGPoint endPoint=buddha.center;
	endPoint.y -= high;
	CGMutablePathRef mutablepath = CGPathCreateMutable();
	CGPathMoveToPoint(mutablepath, NULL, startPoint.x, startPoint.y); // off screen
	CGPathAddLineToPoint(mutablepath, NULL, endPoint.x,endPoint.y);
	CGPathRef path = CGPathCreateCopy(mutablepath);
	CGPathRelease(mutablepath);
	alongPath.path = path;
	alongPath.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	alongPath.delegate=self;
	alongPath.removedOnCompletion=YES;
	alongPath.autoreverses=YES;
	[alongPath setValue:@"jumpupmove" forKey:@"name"];
	
	alongPath.duration = timeToAnimate;
	scale.duration = timeToAnimate;
	[vLayer addAnimation:scale forKey:@"jumpupscale"];
	[vLayer addAnimation:alongPath forKey:@"jumpupmove"];
	[vLayer setPosition:startPoint];
}

- (void) animationLaughingBuddah: (float) duration {
	
	CABasicAnimation *basicAnimation; 
	basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; 
	basicAnimation.fromValue = [NSNumber numberWithFloat:1.0]; 
	basicAnimation.toValue = [NSNumber numberWithFloat:2.5]; 
	basicAnimation.duration = 0.7; 
	basicAnimation.repeatCount = 1; 
}

- (void) animationRotate: (float) duration {
	CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	fullRotation.fromValue = [NSNumber numberWithFloat:0]; 
	fullRotation.toValue = [NSNumber numberWithFloat:(2*M_PI)]; 
	fullRotation.repeatCount = 0; 
	fullRotation.duration = 10;
	fullRotation.delegate=self;
	[fullRotation setValue:@"rotateb" forKey:@"name"];
	[mmbackg.layer addAnimation:fullRotation forKey:@"rotateb"];
  
}

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  //	NSLog(@"animationDidStop ");
	
	if([[theAnimation valueForKey:@"name"] isEqual:@"rotateb"] ) {
		NSLog(@"animation for rotate finished %@",flag?@"YES":@"NO");
		if (flag){
			CABasicAnimation *r=(CABasicAnimation *)theAnimation;
			CGFloat dur = r.duration;
			[self animationRotate: dur];
		}
		
	} else if([[theAnimation valueForKey:@"name"] isEqual:@"jumpupmove"]) {
		
		//NSLog (@"animationDidStop finsihed %@ [jumpupmove] %@",flag?@"YES":@"NO",self);
		if (!flag){
			jumpAnimActive=NO;
			buddha.transform = CGAffineTransformMakeScale(buddhaScale, buddhaScale);
		} else {
			if (jumpUpAndDown){
				if (jumpUpAndDownStop){
					NSLog (@"animation requested to stop");
					jumpAnimActive=NO;
				} else {
					CABasicAnimation *jump=(CABasicAnimation *)theAnimation;
					CGFloat dur = jump.duration;
					[self animationJumpUp: 130.0 duration: dur];
				}
			}
		}
		
	}else if([[theAnimation valueForKey:@"name"] isEqual:@"bouncebyscale"]) {
		
		//NSLog (@"animationDidStop finsihed %@ [bouncebyscale] %@",flag?@"YES":@"NO",self);
		if (!flag){
			bounceAnimActive=NO;
			buddha.transform = CGAffineTransformMakeScale(buddhaScale, buddhaScale);
		} else {
			CABasicAnimation *bounce=(CABasicAnimation *)theAnimation;
			CGFloat dur = bounce.duration;
			[self animationBounceByScale:0 duration:dur
                            timing: kCAMediaTimingFunctionEaseIn];
		}
	}else if([[theAnimation valueForKey:@"name"] isEqual:@"bouncebyframe"]) {
		
		NSLog (@"animationDidStop finsihed %@ [bouncebyframe] %@",flag?@"YES":@"NO",self);
		if (!flag){
			bounceAnimActive=NO;
		} else {
			CABasicAnimation *bounce=(CABasicAnimation *)theAnimation;
			NSValue *v;
			v=bounce.toValue;
			CGRect bb1=[v CGRectValue];
			NSValue *v2;
			
			v2=bounce.fromValue;
			CGRect bb2=[v2 CGRectValue];
			CGFloat dur = bounce.duration;
			
			//bb2.origin.y += skipDrawStep;
			[self animationBounceByFrame: 0 duration:dur rect1: (CGRect) bb1 rect2: (CGRect) bb2 
                            timing:kCAMediaTimingFunctionEaseIn];
		}
	}
	
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
  [super dealloc];
}

@end
