//
//  UIView+Extra.m
//  ElasticPullToRefresh
//
//  Created by Nguyen Hoang Nam on 17/11/15.
//  Copyright © 2015 Nguyen Hoang Nam. All rights reserved.
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

- (CGPoint) dg_center:(BOOL) userPresentationIfPosible {
    if (userPresentationIfPosible) {
        CALayer *presentationLayer = self.layer.presentationLayer;
        return presentationLayer.position;
    }
    return self.center;
}


@end
