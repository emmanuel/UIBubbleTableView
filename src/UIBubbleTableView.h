//
//  UIBubbleTableView.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "SGBubbleTableViewAdapter.h"
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewCell.h"


@interface UIBubbleTableView : UITableView

@property (nonatomic, strong) id<UITableViewDelegate, UITableViewDataSource, SGBubbleTableViewAdapterProtocol> adapter;

#pragma mark Compiler hints

@property (nonatomic, assign) id<UIBubbleTableViewDataSource> bubbleDataSource;

@property (nonatomic) NSTimeInterval snapInterval;
@property (nonatomic) BOOL showAvatars;
@property (nonatomic) NSBubbleTypingType typingBubble;

@end
