//
//  SGBubbleTableViewAdapter.h
//  UIBubbleTableViewExample
//
//  Created by Emmanuel Gomez on 1/8/13.
//  Copyright (c) 2013 Stex Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBubbleTableViewDataSource.h"
#import "SGBubbleTableViewAdapterProtocol.h"

@interface SGBubbleTableViewAdapter : NSObject <UITableViewDelegate, UITableViewDataSource, SGBubbleTableViewAdapterProtocol>

@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, weak) id<UIBubbleTableViewDataSource> bubbleDataSource;

@property (nonatomic, assign) NSTimeInterval snapInterval;
@property (nonatomic, assign) NSBubbleTypingType typingBubble;
@property (nonatomic, assign) BOOL showAvatars;

@property (nonatomic, weak) UIBubbleTableView *bubbleTableView;
@property (nonatomic, strong) NSMutableArray *bubbleSections;

- (id)initWithBubbleTableView:(UIBubbleTableView *)bubbleTableView;
- (id)forwardingTargetForSelector:(SEL)aSelector;
- (BOOL)respondsToSelector:(SEL)aSelector;

- (void)willReloadData;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end