//
//  ViewController.m
//  ElasticPullToRefresh
//
//  Created by Nguyen Hoang Nam on 16/11/15.
//  Copyright © 2015 Nguyen Hoang Nam. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extra.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (strong, nonatomic) UIView *l3ControlPointView;
@property (strong, nonatomic) UIView *l2ControlPointView;
@property (strong, nonatomic) UIView *l1ControlPointView;
@property (strong, nonatomic) UIView *cControlPointView;
@property (strong, nonatomic) UIView *r1ControlPointView;
@property (strong, nonatomic) UIView *r2ControlPointView;
@property (strong, nonatomic) UIView *r3ControlPointView;
@end

@implementation ViewController {
    CGFloat minimalHeight;
    CGFloat maxWaveHeight;
    CAShapeLayer *shapeLayer;
    CADisplayLink *displayLink;
    __block BOOL animating;
}

- (void)setAnimating:(BOOL)animatingState {
    animating = animatingState;
    self.view.userInteractionEnabled = !animating;
    displayLink.paused = !animating;
}

- (id) init {
    if (self = [super init])
    {
        [self initStuffs];
    }
    return self;
}

-(void)awakeFromNib {
    [self initStuffs];
}

- (void) initStuffs {
    
    minimalHeight = 80.0f;
    maxWaveHeight = 100.0f;
    
    shapeLayer = [[CAShapeLayer alloc] init];
    //--
    _l1ControlPointView = [[UIView alloc] init];
    _l2ControlPointView = [[UIView alloc] init];
    _l3ControlPointView = [[UIView alloc] init];
    _cControlPointView = [[UIView alloc] init];
    _r1ControlPointView = [[UIView alloc] init];
    _r2ControlPointView = [[UIView alloc] init];
    _r3ControlPointView = [[UIView alloc] init];
    
    animating = NO;
}

- (void) loadView {
    
    [super loadView];
    
    [shapeLayer setFrame:CGRectMake(0, 0, self.view.bounds.size.width, minimalHeight)];
    
    [shapeLayer setFillColor:[UIColor colorWithRed:57/255.0f green:67/255.0f blue:89/255.0f alpha:1.0f].CGColor];
    [shapeLayer setActions:@{@"position": [NSNull null], @"bounds": [NSNull null], @"path": [NSNull null]}];
    [self.view.layer addSublayer:shapeLayer];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidMove:)]];
    
    //--
    
    [_l3ControlPointView setFrame:CGRectMake(0, 0, 3.0, 3.0)];
    [_l2ControlPointView setFrame:CGRectMake(0, 0, 3.0, 3.0)];
    [_l1ControlPointView setFrame:CGRectMake(0, 0, 3.0, 3.0)];
    [_cControlPointView setFrame:CGRectMake(0, 0, 3.0, 3.0)];
    [_r1ControlPointView setFrame:CGRectMake(0, 0, 3.0, 3.0)];
    [_r2ControlPointView setFrame:CGRectMake(0, 0, 3.0, 3.0)];
    [_r3ControlPointView setFrame:CGRectMake(0, 0, 3.0, 3.0)];
    
    _l3ControlPointView.backgroundColor = [UIColor redColor];
    _l2ControlPointView.backgroundColor = [UIColor redColor];
    _l1ControlPointView.backgroundColor = [UIColor redColor];
    _cControlPointView.backgroundColor = [UIColor redColor];
    _r1ControlPointView.backgroundColor = [UIColor redColor];
    _r2ControlPointView.backgroundColor = [UIColor redColor];
    _r3ControlPointView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_l3ControlPointView];
    [self.view addSubview:_l2ControlPointView];
    [self.view addSubview:_l1ControlPointView];
    [self.view addSubview:_cControlPointView];
    [self.view addSubview:_r1ControlPointView];
    [self.view addSubview:_r2ControlPointView];
    [self.view addSubview:_r3ControlPointView];
    
    [self layoutControlPoints:minimalHeight waveHeight:0.0 locationX:self.view.bounds.size.width / 2.0];
    
    [self updateShapelayer];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateShapelayer)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    displayLink.paused = YES;
}

- (void)panGestureDidMove:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {

        __block CGFloat centerY = minimalHeight;
        
        [self setAnimating:YES];
        
        [UIView animateWithDuration:0.9
                              delay:0.0
             usingSpringWithDamping:0.57
              initialSpringVelocity:0.0
                            options:0
                         animations:^{
                             CGPoint centerPointL3 = self.l3ControlPointView.center;
                             centerPointL3.y = centerY;
                             self.l3ControlPointView.center = centerPointL3;
                             
                             CGPoint centerPointL2 = self.l2ControlPointView.center;
                             centerPointL2.y = centerY;
                             self.l2ControlPointView.center = centerPointL2;
                             
                             CGPoint centerPointL1 = self.l1ControlPointView.center;
                             centerPointL1.y = centerY;
                             self.l1ControlPointView.center = centerPointL1;
                             
                             CGPoint centerPointC = self.cControlPointView.center;
                             centerPointC.y = centerY;
                             self.cControlPointView.center = centerPointC;
                             
                             CGPoint centerPointR1 = self.r1ControlPointView.center;
                             centerPointR1.y = centerY;
                             self.r1ControlPointView.center = centerPointR1;
                             
                             CGPoint centerPointR2 = self.r2ControlPointView.center;
                             centerPointR2.y = centerY;
                             self.r2ControlPointView.center = centerPointR2;
                             
                             CGPoint centerPointR3 = self.r3ControlPointView.center;
                             centerPointR3.y = centerY;
                             self.r3ControlPointView.center = centerPointR3;
                             
        } completion:^(BOOL finished) {
            [self setAnimating:NO];
        }];
        
    } else {

        CGFloat additionalHeight = MAX([gesture translationInView:self.view].y, 0.0);
        CGFloat waveHeight = MIN(additionalHeight*0.6, maxWaveHeight);
        CGFloat baseHeight = minimalHeight + additionalHeight - waveHeight;
        CGFloat locationX = [gesture locationInView:gesture.view].x;

        [self layoutControlPoints:baseHeight waveHeight:waveHeight locationX:locationX];
        [self updateShapelayer];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGPathRef) currentPath {
    
    CGFloat width = self.view.bounds.size.width;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    
    [bezierPath addLineToPoint:CGPointMake(0.0, [_l3ControlPointView dg_center:animating].y)];
    
    [bezierPath addCurveToPoint:[_l1ControlPointView dg_center:animating]
                  controlPoint1:[_l3ControlPointView dg_center:animating]
                  controlPoint2:[_l2ControlPointView dg_center:animating]];
    
    [bezierPath addCurveToPoint:[_r1ControlPointView dg_center:animating]
                  controlPoint1:[_cControlPointView dg_center:animating]
                  controlPoint2:[_r1ControlPointView dg_center:animating]];
    
    [bezierPath addCurveToPoint:[_r3ControlPointView dg_center:animating]
                  controlPoint1:[_r1ControlPointView dg_center:animating]
                  controlPoint2:[_r2ControlPointView dg_center:animating]];
    
    [bezierPath addLineToPoint:CGPointMake(width, 0.0)];
    
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}

- (void) updateShapelayer {
    shapeLayer.path = [self currentPath];
}

- (void) layoutControlPoints:(CGFloat)baseHeight waveHeight:(CGFloat)waveHeight locationX:(CGFloat) locationX {
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat minLeftX = MIN((locationX - width / 2.0) * 0.28, 0.0);
    CGFloat maxRightX = MAX(width + (locationX - width / 2.0) * 0.28, width);
    
    CGFloat leftPartWidth = locationX - minLeftX;
    CGFloat rightPartWidth = maxRightX - locationX;
    
    _l3ControlPointView.center = CGPointMake(minLeftX, baseHeight);
    _l2ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.44, baseHeight);
    _l1ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.71, baseHeight + waveHeight * 0.64);
    
    _cControlPointView.center = CGPointMake(locationX, baseHeight + waveHeight * 1.36);
    
    _r1ControlPointView.center = CGPointMake(maxRightX - rightPartWidth * 0.71, baseHeight + waveHeight * 0.64);
    _r2ControlPointView.center = CGPointMake(maxRightX - rightPartWidth * 0.44, baseHeight);
    _r3ControlPointView.center = CGPointMake(maxRightX, baseHeight);
}

































@end































