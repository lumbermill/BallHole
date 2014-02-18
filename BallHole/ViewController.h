//
//  ViewController.h
//  BallHall
//
//  Created by 伊藤 陽生 on 5/5/12.
//  Copyright (c) 2012 LumberMill, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <UIAccelerometerDelegate, AVAudioPlayerDelegate>
{
@private
    UIImageView *ivBall;
    UIImageView *ivHole;
    UIAccelerationValue dx;
    UIAccelerationValue dy;
    
    AVAudioPlayer *ap0;
    AVAudioPlayer *ap1;
    AVAudioPlayer *ap2;
    
}

@end
