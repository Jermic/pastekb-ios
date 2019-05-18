//
//  ForEachWithRandomDelay.m
//  Keyboard
//
//  Created by everettjf on 2019/5/15.
//  Copyright © 2019 everettjf. All rights reserved.
//

#import "ForEachWithRandomDelay.h"

@interface ForEachWithRandomDelay ()
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,strong) NSString* accumulateString;
@end

@implementation ForEachWithRandomDelay

- (instancetype)init
{
    self = [super init];
    if (self) {
        _accumulateString = @"";
        _currentIndex = 0;
    }
    return self;
}

- (void)forEach{
    self.currentIndex = 0;
    [self next];
}

- (void)next{
    
    double delayMs = 50+ arc4random() % 100;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayMs/1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.stopped){
            return;
        }
        
        if(self.currentIndex >= self.items.count){
            return;
        }
        
        NSString *currentString = self.items[self.currentIndex];
        if ([currentString isEqualToString:@"@"]
            || [currentString isEqualToString:@"\n"]
            ){
            self.accumulateString = [self.accumulateString stringByAppendingString:currentString];
        } else {
            if (self.accumulateString.length > 0) {
                self.accumulateString = [self.accumulateString stringByAppendingString:currentString];
                self.action(self.accumulateString);
                self.accumulateString = @"";
            } else {
                self.action(currentString);
            }
        }
        
        self.currentIndex += 1;
        
        [self next];
    });
}

@end
