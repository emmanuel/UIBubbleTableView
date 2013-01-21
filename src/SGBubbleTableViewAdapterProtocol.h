//
//  SGBubbleTableViewAdapterProtocol.h
//  UIBubbleTableViewExample
//
//  Created by Emmanuel Gomez on 1/9/13.
//  Copyright (c) 2013 Stex Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGBubbleTableViewDataSource.h"

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSInteger, SGBubbleTypingDirection)
{
    SGBubbleTypingDirectionNone,
    SGBubbleTypingDirectionRight,
    SGBubbleTypingDirectionLeft,
};

@protocol SGBubbleTableViewAdapterProtocol <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, weak) id<SGBubbleTableViewDataSource> bubbleDataSource;

@property (nonatomic, assign) NSTimeInterval snapInterval;
@property (nonatomic, assign) BOOL showAvatars;

@required
- (void)willReloadData;

@optional
- (void)didReloadData;

@end
