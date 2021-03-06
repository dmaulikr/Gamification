//
//  SpecificRewardsViewController.m
//  Gamification
//
//  Created by Michael Overstreet on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpecificRewardsViewController.h"
#import "AddRewardsViewController.h"
#import "DeleteRewardsViewController.h"

@implementation SpecificRewardsViewController
@synthesize commonLabel;
@synthesize uncommonLabel;
@synthesize rareLabel;
@synthesize legendaryLabel;
@synthesize viewTitle;
@synthesize dataSource = _dataSource;
@synthesize instruction = _instruction;

-(void) setup:(id <RewardsViewDataSource>)dataSource withInstruction:(NSString *)instruction
{
    self.dataSource = dataSource;
    self.instruction = instruction;
}
- (IBAction)buttonPressed:(id)sender {
    NSString *titleHolder = [[@"segueTo" stringByAppendingString:self.instruction] stringByAppendingString:@"Rewards"];
    [self performSegueWithIdentifier:titleHolder sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setup:self.dataSource withType: ((UIButton *) sender).titleLabel.text];
    /*if ([[segue identifier] isEqualToString:@"segueToAddRewards"]) {
        [(AddRewardsViewController *) segue.destinationViewController setup:self.dataSource withType:((UIButton *) sender).titleLabel.text];
    }
    else if([[segue identifier] isEqualToString:@"segueToDeleteRewards"]) {
        [(DeleteRewardsViewController *)  segue.destinationViewController setup:self.dataSource withType: ((UIButton *) sender).titleLabel.text];
    }*/
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary * holder;
    if([self.instruction isEqualToString:@"Use"])
        holder = [[NSDictionary alloc] initWithDictionary:[self.dataSource availableRewardCounts]];
    else
        holder = [[NSDictionary alloc ] initWithDictionary:[self.dataSource rewardCounts]];
    commonLabel.text = [[holder objectForKey:@"Common"] stringValue];
    uncommonLabel.text = [[holder objectForKey:@"Uncommon"] stringValue];
    rareLabel.text = [[holder objectForKey:@"Rare"] stringValue];
    legendaryLabel.text = [[holder objectForKey:@"Legendary"] stringValue];
    viewTitle.title = [self.instruction stringByAppendingString:@" Rewards"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*NSDictionary *holder = [[NSDictionary alloc ] initWithDictionary:[self.dataSource rewardCounts]];
    commonLabel.text = [[holder objectForKey:@"Common"] stringValue];
    uncommonLabel.text = [[holder objectForKey:@"Uncommon"] stringValue];
    rareLabel.text = [[holder objectForKey:@"Rare"] stringValue];
    legendaryLabel.text = [[holder objectForKey:@"Legendary"] stringValue];
    viewTitle.title = [self.instruction stringByAppendingString:@" Rewards"];*/
}


- (void)viewDidUnload
{
    [self setCommonLabel:nil];
    [self setUncommonLabel:nil];
    [self setRareLabel:nil];
    [self setLegendaryLabel:nil];
    [self setViewTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
