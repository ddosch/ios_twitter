//
//  ComposeViewController.m
//  twitter
//
//  Created by Dan Dosch on 1/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (strong, nonatomic) UILabel *charsLeft;
@property (strong, nonatomic) UIBarButtonItem *tweetButton;

- (void)tweet;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweet)];
    self.navigationItem.rightBarButtonItem = self.tweetButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.charsLeft = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 160.0, 44.0)];
    self.charsLeft.text = @"140";
    self.charsLeft.textAlignment = UITextAlignmentRight;
    self.navigationItem.titleView = self.charsLeft;
    
    self.username.text = [User currentUserName];
    self.screenName.text = [User currentUserScreenName];
    [self.profileImage setImageWithURL:[User currentUserProfileImageURL]];
    
    if (self.replyTo != nil) {
        self.tweetTextView.text = self.replyTo;
        self.tweetTextView.textColor = [UIColor blackColor];
        self.charsLeft.text = [NSString stringWithFormat:@"%d", 140 - self.tweetTextView.text.length];
    }
    
    self.tweetTextView.delegate = self;
    [self.tweetTextView becomeFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"This was called");
    if ([textView.text isEqualToString:@"What's happening?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"What's happening?.";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.tweetButton.enabled = YES;
    } else {
        self.tweetButton.enabled = NO;
    }
    self.charsLeft.text = [NSString stringWithFormat:@"%d", 140 - textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return (textView.text.length + text.length) <= 140;
}

- (void)tweet {
    [[TwitterClient instance] tweet:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
