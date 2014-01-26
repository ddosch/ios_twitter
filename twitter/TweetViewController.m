//
//  TweetViewController.m
//  twitter
//
//  Created by Dan Dosch on 1/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *retweets;
@property (weak, nonatomic) IBOutlet UILabel *favorites;
@property (weak, nonatomic) IBOutlet UIButton *favoriteImageView;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

- (IBAction)replyTap:(id)sender;
- (IBAction)retweetTap:(id)sender;
- (IBAction)favoriteTap:(id)sender;

- (void)compose;

@end

@implementation TweetViewController

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
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Twitter_logo_blue.png"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"187-pencil.png"] style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
    
    [self.profileImage setImageWithURL:self.tweet.profileImageURL];
    self.username.text = self.tweet.username;
    self.screenName.text = self.tweet.screenName;
    self.tweetText.text = self.tweet.text;
    self.tweetDate.text = self.tweet.tweetDateFull;
    self.retweets.text = self.tweet.retweets;
    self.favorites.text = self.tweet.favorites;
    
    if (self.tweet.favorited) {
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite copy.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet copy.png"] forState:UIControlStateNormal];
    }
    
    if ([self.tweet.screenName isEqualToString:[User currentUserScreenName]]) {
        self.retweetButton.hidden = YES;
        self.retweetButton.enabled = NO;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)replyTap:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:[NSBundle mainBundle]];
    cvc.replyTo = self.tweet.screenName;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)retweetTap:(id)sender {
    [[TwitterClient instance] retweet:self.tweet.idStr success:^(AFHTTPRequestOperation *operation, id response) {
        
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet copy.png"] forState:UIControlStateNormal];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (IBAction)favoriteTap:(id)sender {
    [[TwitterClient instance] favorite:self.tweet.idStr success:^(AFHTTPRequestOperation *operation, id response) {
        [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite copy.png"] forState:UIControlStateNormal];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];

}

- (void)compose {
    ComposeViewController *cvc = [[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
