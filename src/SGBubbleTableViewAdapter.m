//
//  SGBubbleTableViewAdapter.m
//  UIBubbleTableViewExample
//
//  Created by Emmanuel Gomez on 1/8/13.
//  Copyright (c) 2013 Stex Group. All rights reserved.
//

#import "SGBubbleTableViewAdapter.h"
#import "SGBubbleData.h"
#import "SGBubbleTableView.h"
#import "SGBubbleTableViewContentCell.h"
#import "SGBubbleTableViewHeaderCell.h"
#import "SGBubbleTableViewTypingCell.h"

@interface SGBubbleTableViewAdapter ()

@end

@implementation SGBubbleTableViewAdapter

#pragma mark - Initializer

- (id)initWithBubbleTableView:(SGBubbleTableView *)bubbleTableView
{
    self = [super init];
    if (self)
    {
        NSParameterAssert(UITableViewStylePlain == bubbleTableView.style);
        self.bubbleTableView = bubbleTableView;
        self.bubbleSections = [[NSMutableArray alloc] init];
#if !__has_feature(objc_arc)
        [self.bubbleSections autorelease];
#endif
        self.snapInterval = 120;
        self.typingBubble = NSBubbleTypingTypeNobody;
    }

    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector:aSelector])
    {
        return self.delegate;
    }
    else
    {
        return [super forwardingTargetForSelector:aSelector];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return ([super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector]);
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [self.bubbleSections release];
	self.bubbleSections = nil;
	self.bubbleDataSource = nil;
    [super dealloc];
}
#endif

#pragma mark - UITableViewDataSource implementations

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSections count];
    if (NSBubbleTypingTypeNobody != self.typingBubble) result++;

    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is for now typing bubble
	if (section >= [self.bubbleSections count]) return 1;
    
    return [[self.bubbleSections objectAtIndex:section] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
    if (indexPath.section >= [self.bubbleSections count])
    {
        static NSString *cellId = @"tblBubbleTypingCell";
        SGBubbleTableViewTypingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) cell = [[SGBubbleTableViewTypingCell alloc] init];
        
        cell.type = self.typingBubble;
        cell.showAvatar = self.showAvatars;
        
        return cell;
    }
    
    // Header with date and time
    if (indexPath.row == 0)
    {
        static NSString *cellId = @"tblBubbleHeaderCell";
        SGBubbleTableViewHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        SGBubbleData *data = [[self.bubbleSections objectAtIndex:indexPath.section] objectAtIndex:0];
        
        if (cell == nil) cell = [[SGBubbleTableViewHeaderCell alloc] init];
        
        cell.date = data.date;
        
        return cell;
    }
    
    // Standard bubble
    static NSString *cellId = @"tblBubbleCell";
    SGBubbleTableViewContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    SGBubbleData *data = [[self.bubbleSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    
    if (cell == nil) cell = [[SGBubbleTableViewContentCell alloc] init];
    
    cell.data = data;
    cell.showAvatar = self.showAvatars;
    
    return cell;
}

#pragma mark - UITableViewDelegate implementations

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSections count])
    {
        return MAX([SGBubbleTableViewTypingCell height], self.showAvatars ? 52 : 0);
    }
    
    // Header
    if (indexPath.row == 0)
    {
        return [SGBubbleTableViewHeaderCell height];
    }
    
    SGBubbleData *data = [[self.bubbleSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom, self.showAvatars ? 52 : 0);
}

#pragma mark - SGBubbleTableViewAdapterProtocol implementations

- (void)willReloadData
{
    // Cleaning up
	self.bubbleSections = nil;
    
    // Loading new data
    int count = [self.bubbleDataSource numberOfRowsForBubbleTableView:self.bubbleTableView];
    self.bubbleSections = [[NSMutableArray alloc] init];
#if !__has_feature(objc_arc)
    [self.bubbleSections autorelease];
#endif

    if (self.bubbleDataSource && (count > 0))
    {
        NSMutableArray *bubbleData = [[NSMutableArray alloc] initWithCapacity:count];
#if !__has_feature(objc_arc)
        [bubbleData autorelease];
#endif
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self.bubbleTableView dataForRow:i];
            assert([object isKindOfClass:[SGBubbleData class]]);
            [bubbleData addObject:object];
        }

        [bubbleData sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             SGBubbleData *bubbleData1 = (SGBubbleData *)obj1;
             SGBubbleData *bubbleData2 = (SGBubbleData *)obj2;
             
             return [bubbleData1.date compare:bubbleData2.date];
         }];

        NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
        NSMutableArray *currentSection = nil;

        for (int i = 0; i < count; i++)
        {
            SGBubbleData *data = (SGBubbleData *)[bubbleData objectAtIndex:i];
            
            if ([data.date timeIntervalSinceDate:last] > self.snapInterval)
            {
                currentSection = [[NSMutableArray alloc] init];
#if !__has_feature(objc_arc)
                [currentSection autorelease];
#endif
                [self.bubbleSections addObject:currentSection];
            }
            
            [currentSection addObject:data];
            last = data.date;
        }
    }
}

@end
