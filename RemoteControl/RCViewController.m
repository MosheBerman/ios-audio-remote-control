//
//  RCViewController.m
//  RemoteControl
//
//  Created by Moshe Berman on 10/1/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "RCViewController.h"

#import "Notifications.h"

#import <AVFoundation/AVFoundation.h>

extern NSString *remoteControlPlayButtonTapped;
extern NSString *remoteControlPauseButtonTapped;
extern NSString *remoteControlStopButtonTapped;
extern NSString *remoteControlForwardButtonTapped;
extern NSString *remoteControlBackwardButtonTapped;
extern NSString *remoteControlOtherButtonTapped;

@interface RCViewController ()

@property (strong, nonatomic) IBOutlet UITextView *log;

@property (strong, nonatomic) NSString *initialText;

@property (strong, nonatomic) AVPlayer *player;
@end

@implementation RCViewController

- (id)init
{
    self = [super init];
    if (self) {
        _initialText = NSLocalizedString(@"The log is empty.", @"A string that describes an empty log.");
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    if (!self.log.text.length) {
        self.log.text = self.initialText;
    }
    
    /*
     *  Listen for the appropriate notifications.
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlPlayButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlPauseButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlStopButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlForwardButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlBackwardButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlOtherButtonTapped object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* 
     *  Without some sort of 
     *  audio player, the remote
     *  remains unavailable to this
     *  app, and the previous app will 
     *  maintain control over it.
     */
    
    _player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://stream.jewishmusicstream.com:8000"]];
    
    /*  Kicking off playback takes over
     *  the software based remote control
     *  interface in the lock screen and 
     *  in Control Center.
     */
    
    [_player play];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Remote Handling

/*  This method logs out when a 
 *  remote control button is pressed.
 *
 *  In some cases, it will also manipulate the stream.
 */

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:remoteControlPlayButtonTapped]) {
        [self updateLogWithMessage:NSLocalizedString(@"Play remote event recieved.", @"A log event for play events.")];
        [[self player] play];
        
    } else  if ([notification.name isEqualToString:remoteControlPauseButtonTapped]) {
        [self updateLogWithMessage:NSLocalizedString(@"Pause remote event recieved.", @"A log event for pause events.")];
        [[self player] pause];
        
    } else if ([notification.name isEqualToString:remoteControlStopButtonTapped]) {
        [self updateLogWithMessage:NSLocalizedString(@"Stop remote event recieved.", @"A log event for stop events.")];
        [[self player] pause];
        
    } else if ([notification.name isEqualToString:remoteControlForwardButtonTapped]) {
        [self updateLogWithMessage:NSLocalizedString(@"Forward remote event recieved.", @"A log event for next events.")];
        
    } else if ([notification.name isEqualToString:remoteControlBackwardButtonTapped]) {
        [self updateLogWithMessage:NSLocalizedString(@"Back remote event recieved.", @"A log event for back events.")];
    }
    else {
        [self updateLogWithMessage:NSLocalizedString(@"Unknown remote event recieved.", @"A log event for unknown events.")];
    }
    
}

#pragma mark - Log Updating

- (void)updateLogWithMessage:(NSString *)message
{
    if ([self.log.text isEqualToString:self.initialText]) {
        self.log.text = [NSMutableString stringWithFormat:@"%@: %@", [NSDate date], message];
    }
    else {
        self.log.text = [NSMutableString stringWithFormat:@"%@\n%@: %@", self.log.text, [NSDate date], message];
    }
}



@end
