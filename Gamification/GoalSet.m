//
//  GoalSet.m
//  Gamification
//
//  Created by Michael Overstreet on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoalSet.h"
#import "Constants.h"
#import "Goal.h"

@interface GoalSet()

@property (nonatomic) goalsize chanceIndex;
@property (nonatomic) int expGain;
@property (nonatomic) double legendaryChance;
@property (nonatomic) double rareChance;
@property (nonatomic) double uncommonChance;
@property (nonatomic) double commonChance;
@end

@implementation GoalSet

@synthesize goalType = _goalType, goals = _goals, theUser = _theUser, size = _size, keys = _keys;
@synthesize expGain = _expGain, legendaryChance = _legendaryChance, rareChance = _rareChance, uncommonChance = _uncommonChance, commonChance = _commonChance, chanceIndex = _chanceIndex;


//private setters -----------------
-(void) setGoalType:(NSString *)goalType
{
    _goalType = goalType;
}

- (void)setTheUser:(UserStatus *)theUser
{
    _theUser = theUser;
}

- (void)setGoals:(NSMutableArray *)goals
{
    _goals = goals;
}

- (void)setSize:(int)size
{
    _size = size;
}

- (void)setKeys:(NSMutableSet *)keys
{
    _keys = keys;
}
//----------------------------

- (void) readFromFile
{
    NSArray *temp = [[NSArray alloc] init];
    NSURL *path = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    path = [path URLByAppendingPathComponent:[@"GoalSet" stringByAppendingString:self.goalType]];
    temp = [NSArray arrayWithContentsOfURL:path];
    if([temp count] == 3)
    {
        self.goals = [temp objectAtIndex:0];
        self.size = [[temp objectAtIndex:1] intValue];
        NSArray * holder = [temp objectAtIndex:2];
        NSEnumerator *enumerator = [holder objectEnumerator];
        id key;
        while (key = [enumerator nextObject]) {
            [self.keys addObject:[[Goal alloc] initWithPlist:key]];
        }
    }
}

- (void) writeToFile
{
    NSURL *path = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    path = [path URLByAppendingPathComponent:[@"GoalSet" stringByAppendingString:self.goalType]];
    NSEnumerator *enumerator = [self.keys   objectEnumerator];
    Goal *key;
    NSMutableArray *goalSet = [[NSMutableArray alloc] init];
    while(key = [enumerator  nextObject]){
        [goalSet addObject:[key plist]];
    }
    NSArray *temp = [[NSArray alloc] initWithObjects:self.goals, [[NSNumber alloc] initWithInt:self.size], goalSet, nil];
    [temp writeToURL:path atomically:YES];
}

//must be called for proper initialization
- (id) initWithType:(NSString *) type User:(UserStatus *) user
{
    self = [super init];
    if(self){
        self.goalType = type;
        self.theUser = user;
        self.goals = [[NSMutableArray alloc] init ];
        self.size = 0;
        self.keys = [[NSMutableSet alloc] init ];
    
        if(type == @"Everyday")
            self.chanceIndex = Everyday;
        else if(type == @"Tiny")
            self.chanceIndex = Tiny;
        else if(type == @"Small")
            self.chanceIndex = Small;
        else if(type == @"Medium")
            self.chanceIndex = Medium;
        else if(type == @"Large")
            self.chanceIndex = Large;
        else if(type == @"Epic")
            self.chanceIndex = Epic;
        else
            ;//TODO: handle error
        
        self.expGain = kExpGain[self.chanceIndex];
        self.commonChance = kCommonChance[self.chanceIndex];
        self.uncommonChance = kUncommonChance[self.chanceIndex];
        self.rareChance = kRareChance[self.chanceIndex];
        self.legendaryChance = kEpicChance[self.chanceIndex];
        [self readFromFile];
    }
    return self;
}

//TODO: Add error checking

- (void)initGoal:(NSString *)type
{
    self.goalType = type;
    
}

- (void)addGoal:(NSString *)theGoal
{
    [self.goals addObject:theGoal];
    [self.keys addObject:[[Goal alloc] initWithTitle:theGoal]];
    self.size++;
    [self writeToFile];
}

- (void)deleteGoal:(NSString *)theGoal
{
    [self.goals removeObject:theGoal];
    [self.keys addObject:[[Goal alloc] initWithTitle:theGoal]];
    self.size--;
    [self writeToFile];
}

//private
- (void)gainExp
{
    [self.theUser incrementExp:self.expGain];
}

//private
- (NSString *)rollForReward
{
    long long ARC4RANDOM_MAX = 0x100000000;  
    long long holder = arc4random();
    double epicRoll = (double)holder / ARC4RANDOM_MAX;
    if(epicRoll <= self.legendaryChance * (1 + [self.theUser.level intValue] * kLevelValue + [[[self theUser] stack] intValue] * kStackValue)) return @"Legendary";
    holder = arc4random();
    double rareRoll = (double)holder / ARC4RANDOM_MAX;
    if(rareRoll <= self.rareChance * (1 + [self.theUser.level intValue] * kLevelValue + [[[self theUser] stack] intValue] * kStackValue)) return @"Rare";
    holder = arc4random();
    double uncommonRoll = (double)holder /ARC4RANDOM_MAX;
    if(uncommonRoll <= self.uncommonChance * (1 + [self.theUser.level intValue] * kLevelValue + [[[self theUser] stack] intValue] * kStackValue)) return @"Uncommon";
    holder = arc4random();
    double commonRoll = (double)holder / ARC4RANDOM_MAX;
    if(commonRoll <= self.commonChance * (1 + [self.theUser.level intValue] * kLevelValue + [[[self theUser] stack] intValue] * kStackValue)) return @"Common";
    
    return @"";
}

- (NSString *)performGoal
{
    [self.theUser addToHistory:self.goalType];
    [self gainExp];
    return [self rollForReward];
}


@end
