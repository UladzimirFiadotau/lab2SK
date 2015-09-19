//
//  ViewController.m
//  AppleTreeMobile
//
//  Created by Admin on 18.09.15.
//  Copyright (c) 2015 Uladzimir. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AppleTree.h"

const int PICTURES_COUNT = 5;

@interface ViewController () {
    AppleTree *_appleTree;
    int _currAppleCount;
    int _maxAppleCount;
    int _minAppleCount;
    double _avrgAppleCount;
    int _time;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *appleImage;
@property (weak, nonatomic) IBOutlet UILabel *currentAppleCount;
@property (weak, nonatomic) IBOutlet UILabel *minimumAppleCount;
@property (weak, nonatomic) IBOutlet UILabel *maximumAppleCount;
@property (weak, nonatomic) IBOutlet UILabel *lastEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageAppleCount;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _appleTree = [appDelegate appleTree];
    
    _currAppleCount = _maxAppleCount = _minAppleCount = [_appleTree getAppleCount];
    [self updateAppleCountLabelsAndPicture];
    
    NSMutableString *msg = [[NSMutableString alloc] initWithFormat:@"Apple tree grown with %d apples",  _currAppleCount];
    [_lastEventLabel setText:msg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonGrowTouchDown:(id)sender {
    int appleCount = [_appleTree getAppleCount];
    [_appleTree grown];
    [self updateAppleCountLabelsAndPicture];
    appleCount = [_appleTree getAppleCount] - appleCount;
    
    NSMutableString *msg = [[NSMutableString alloc] initWithFormat:@"Grown %d apples", appleCount];
    [_lastEventLabel setText:msg];
    //[self displayAlertMessage:msg];
}

- (IBAction)buttonShakeTouchDown:(id)sender {
    int appleCount = [_appleTree getAppleCount];
    [_appleTree shake];
    [self updateAppleCountLabelsAndPicture];
    appleCount -= [_appleTree getAppleCount];
    
    NSMutableString *msg = [[NSMutableString alloc] initWithFormat:@"Shaked %d apples", appleCount];
    [_lastEventLabel setText:msg];
    //[self displayAlertMessage:msg];
}


- (void) updateAppleCountLabelsAndPicture {
    _time++;
    
    if ([_appleTree getAppleCount] >= _maxAppleCount) {
        _maxAppleCount = [_appleTree getAppleCount];
        [_maximumAppleCount setText:[NSString stringWithFormat:@"%d", _maxAppleCount]];
    }
    
    if ([_appleTree getAppleCount] <= _minAppleCount) {
        _minAppleCount = [_appleTree getAppleCount];
        [_minimumAppleCount setText:[NSString stringWithFormat:@"%d", _minAppleCount]];
    }
    
    _currAppleCount = [_appleTree getAppleCount];
    [_currentAppleCount setText:[NSString stringWithFormat:@"%d", [_appleTree getAppleCount]]];
    
    _avrgAppleCount = (_avrgAppleCount * (_time - 1) +  _currAppleCount) / _time;
    [_averageAppleCount setText:[NSString stringWithFormat:@"%.2f", _avrgAppleCount]];
    
    [self updateAppleTreePicture];
}

- (void) updateAppleTreePicture {
    int picture = PICTURES_COUNT;
    if (_currAppleCount != 0) {
        if (_minAppleCount != _maxAppleCount)
            picture -= (_currAppleCount - _minAppleCount - 1) * PICTURES_COUNT / (_maxAppleCount - _minAppleCount);
        if (picture < 1)
            picture = 1;
    }
    else
        picture = 0;
    [_appleImage setImage:[ViewController imageFromFile:[NSString stringWithFormat:@"apple%d.jpg", picture]]];

}

+ (UIImage*)imageFromFile:(NSString*)aFileName; {
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    //NSLog(@"%@/%@", bundlePath,aFileName);
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",bundlePath,aFileName]];
}

- (void) displayAlertMessage: (NSString*) msg {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
