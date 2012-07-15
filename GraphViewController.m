//
//  GraphViewController.m
//  Calculator
//
//  Created by Michael Hartman on 7/10/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) UIBarButtonItem *splitViewBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *programDisplayBarButtonItem;
@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize programDisplayBarButtonItem = _programDisplayBarButtonItem;

- (void)setProgram:(id)program 
{
    if (_program != program) {
        _program = program;
        self.title = [CalculatorBrain descriptionOfProgram:self.program];
        self.programDisplayBarButtonItem.title = self.title;
        [self.graphView setNeedsDisplay];
    }
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.splitViewController.delegate = self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // restore the view's origin and scale from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    CGFloat originX = [prefs floatForKey:@"origin.x"];
    CGFloat originY = [prefs floatForKey:@"origin.y"];
    self.graphView.origin = CGPointMake(originX, originY);
    self.graphView.scale = [prefs floatForKey:@"scale"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save view's origin and scale to user preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:self.graphView.origin.x forKey:@"origin.x"];
    [prefs setFloat:self.graphView.origin.y forKey:@"origin.y"];
    [prefs setFloat:self.graphView.scale forKey:@"scale"];
    [prefs synchronize];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [self setProgram:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapGestureRecognizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGestureRecognizer];
}

- (double)verticalPointForGraphView:(GraphView *)sender atHorizontalPoint:(double)x
{
    NSDictionary *variableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:x], @"x", nil];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.splitViewBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return !(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
