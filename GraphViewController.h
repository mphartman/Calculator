//
//  GraphViewController.h
//  Calculator
//
//  Created by Michael Hartman on 7/10/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>
@property (nonatomic, strong) id program;  // the program to graph
@end
