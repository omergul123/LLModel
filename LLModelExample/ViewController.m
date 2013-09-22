//
//  ViewController.m
//  LLModelExample
//
//  Created by Ömer Faruk Gül on 9/22/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "ViewController.h"
#import "AFJSONRequestOperation.h"
#import "User.h"
#import "Feed.h"

@interface ViewController ()
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) User *user;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
	
    // Test button
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(0, 0, 130, 46);
    [self.button setTitle:@"Load Models" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    // Status label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.label.textColor = [UIColor darkGrayColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.button.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    self.label.center = CGPointMake(self.button.center.x, self.button.center.y - 100);
}

- (void)buttonPressed:(UIButton *)button
{
    self.button.enabled = NO;
    self.label.text = @"Loading...";
    [self loadJSON];
}

- (void)loadJSON
{
    // The JSON from the folowing URL is generated specially for this project.
    NSURL *url = [NSURL URLWithString:@"http://www.dailypul.se/api/v1/test/llmodel"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //NSLog(@"The JSON: %@", JSON);
        
        // Simply init the user with JSON, that's all!
        self.user = [[User alloc] initWithJSON:JSON];
        
        Feed *feed = [self.user.feeds objectAtIndex:0];
        
        // Log the model values
        NSLog(@"User description: %@", self.user.description);
        NSLog(@"User Address description: %@", self.user.address.description);
        NSLog(@"User Feed[0] description: %@", feed.description);
        
        self.button.enabled = YES;
        self.label.text = @"Models initialized.";
        
    } failure:nil];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
