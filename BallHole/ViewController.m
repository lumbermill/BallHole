//
//  ViewController.m
//  BallHall
//
//  Created by 伊藤 陽生 on 5/5/12.
//  Copyright (c) 2012 LumberMill, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)putHoleAndBall
{
    ivBall.alpha = 0.0;
    ivBall.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.4, 1.4);
    ivHole.alpha = 0.0;
    ivHole.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.4, 1.4);
    
    const float MARGIN = 48.0 + 12.0;
    float x = random() % 2 == 0 ? MARGIN : self.view.bounds.size.width - MARGIN;
    float y = random() % 2 == 0 ? MARGIN : self.view.bounds.size.height - MARGIN;
    
    ivHole.center = CGPointMake(x, y);
    
    dx = dy = 0.0;
    
    ivBall.center = self.view.center;
    [UIView animateWithDuration:0.3
                     animations:^{
                         ivBall.alpha = 1.0;
                         ivBall.transform = CGAffineTransformIdentity;
                         ivHole.alpha = 1.0;
                         ivHole.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         UIAccelerometer *ac = [UIAccelerometer sharedAccelerometer];
                         ac.updateInterval = 1.0 / 45.0;
                         ac.delegate = self;
                     }];
}

- (BOOL)withinHole: (CGPoint) p
{
    float x = p.x - ivHole.center.x;
    float y = p.y - ivHole.center.y;
    float d = sqrtf(x * x + y * y);
    return d < 48.0 - 4.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *imageBall = [UIImage imageNamed:@"ball.png"];
    UIImage *imageHole = [UIImage imageNamed:@"hole.png"];
    ivBall = [[UIImageView alloc] initWithImage:imageBall];
    ivBall.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    ivHole = [[UIImageView alloc] initWithImage:imageHole];
    
    [self.view addSubview:ivHole];
    [self.view addSubview:ivBall];
    //self.view.backgroundColor = [UIColor colorWithRed:0.3046 green:0.6015 blue:0.023 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:0.4492 green:0.8203 blue:0.085 alpha:1.0];
    
    // 効果音
    NSURL *url1 = [[NSBundle mainBundle] URLForResource: @"se_maoudamashii_system10"
                                          withExtension: @"wav"];
    ap1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    [ap1 setDelegate:self];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource: @"se_maoudamashii_magical08"
                                          withExtension: @"wav"];
    ap2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    [ap2 setDelegate:self];
    
    // BGM
    NSURL *url_bg = [[NSBundle mainBundle] URLForResource: @"game_maoudamashii_7_event43"
                                            withExtension: @"wav"];
    ap0 = [[AVAudioPlayer alloc] initWithContentsOfURL:url_bg error:nil];
    ap0.numberOfLoops = -1;
    ap0.volume = 0.4;
    [ap0 setDelegate:self];
    [ap0 play];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self putHoleAndBall];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIAccelerometer *ac = [UIAccelerometer sharedAccelerometer];
    ac.delegate = nil;    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    dx += acceleration.x / 2.0;
    dy += acceleration.y / 2.0;
    CGFloat px = ivBall.center.x + dx;
    CGFloat py = ivBall.center.y - dy;
    
    if ([self withinHole:CGPointMake(px, py)]) {
        UIAccelerometer *ac = [UIAccelerometer sharedAccelerometer];
        ac.delegate = nil;    
        // TODO ボールが小さくなるアニメーションを開始
        [ap2 play];
        
        ivBall.center = CGPointMake(px,py);
        ivBall.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn 
                         animations:^{
                             //NSLog(@"ball=[%f, %f] hole=[%f,%f]",ivBall.center.x,ivBall.center.y,ivHole.center.x,ivHole.center.y);
                             ivBall.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
                             ivBall.center = ivHole.center;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"animation complete.");
                             [self putHoleAndBall];
                         }];
        return;
    }
    
    if (px < 0.0) {
        px = 0.0;
        dx *= -0.4;
        [ap1 play];
    }else if (px > self.view.bounds.size.width) {
        px = self.view.bounds.size.width;
        dx *= -0.4;
        [ap1 play];
    }
    if (py < 0.0){
        py = 0.0;
        // dy = 0.0; no bounds.
        dy *= -0.4;
        [ap1 play];
    }else if(py > self.view.bounds.size.height){
        py = self.view.bounds.size.height;
        // dy *= -1.5; high bounds.
        dy *= -0.4;
        [ap1 play];
    }
    ivBall.center = CGPointMake(px,py);    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
