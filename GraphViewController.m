//
//  GraphViewController.m
//  Calculator
//
//  Created by Michael Hartman on 7/10/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController ()
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize graphView = _graphView;
@end
