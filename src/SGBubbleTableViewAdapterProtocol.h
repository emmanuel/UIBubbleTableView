//
//  SGBubbleTableViewAdapterProtocol.h
//  UIBubbleTableViewExample
//
//  Created by Emmanuel Gomez on 1/9/13.
//  Copyright (c) 2013 Stex Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGBubbleTableViewDataSource.h"

typedef enum NSBubbleTypingType : NSInteger NSBubbleTypingType; enum NSBubbleTypingType : NSInteger
{
    NSBubbleTypingTypeNobody,
    NSBubbleTypingTypeMe,
    NSBubbleTypingTypeSomebody
};

@protocol SGBubbleTableViewAdapterProtocol <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, weak) id<SGBubbleTableViewDataSource> bubbleDataSource;

@property (nonatomic, assign) NSTimeInterval snapInterval;
@property (nonatomic, assign) NSBubbleTypingType typingBubble;
@property (nonatomic, assign) BOOL showAvatars;

@required
- (void)willReloadData;

@optional
- (void)didReloadData;

@end
