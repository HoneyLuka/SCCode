//
//  KEPVideoPlayerFullScreenAnimator.m
//  KEPVideoPlayer
//
//  Created by Luka Li on 7/1/2019.
//

#import "KEPVideoPlayerFullScreenAnimator.h"
#import "KEPVideoPlayerViewController.h"

@interface KEPVideoPlayerFullScreenAnimator ()

@property (nonatomic, weak) UIView *oldSuperView;
@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, weak) UIView *dismissedPlayerViewRef;

@end

@implementation KEPVideoPlayerFullScreenAnimator

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([toViewController isKindOfClass:KEPVideoPlayerViewController.class]) {
        // show
        [self animateTransitionForShow:transitionContext];
        return;
    }
    
    // dismiss
    [self animateTransitionForDismiss:transitionContext];
}

- (void)animateTransitionForShow:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // 因为是show操作，清空playerView引用
    self.dismissedPlayerViewRef = nil;
    
    UIView *containerView = [transitionContext containerView];
    
    // to vc
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *playerView = toViewController.view;
    
    self.oldSuperView = playerView.superview;
    self.oldFrame = playerView.frame;
    CGPoint oldCenter = CGPointMake(CGRectGetMidX(self.oldFrame), CGRectGetMidY(self.oldFrame));
    CGPoint prepareCenter = [self.oldSuperView convertPoint:oldCenter toView:containerView];
    
    [playerView removeFromSuperview];
    [containerView addSubview:playerView];
    
    playerView.center = prepareCenter;
    playerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        playerView.transform = CGAffineTransformIdentity;
        playerView.frame = [transitionContext finalFrameForViewController:toViewController];
        [playerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (void)animateTransitionForDismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    
    // to vc
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = containerView.bounds;
    [containerView addSubview:toViewController.view];
    
    // from vc
    UIViewController *videoVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *playerView = videoVC.view;
    
    [containerView addSubview:playerView];
    
    self.dismissedPlayerViewRef = playerView;
    
    CGRect animateEndFrame =
    [self.oldSuperView convertRect:self.oldFrame toView:containerView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        playerView.transform = CGAffineTransformIdentity;
        playerView.frame = animateEndFrame;
        [playerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted {
    if (!transitionCompleted) {
        return;
    }
    
    if (!self.dismissedPlayerViewRef) {
        return;
    }
    
    [self.dismissedPlayerViewRef removeFromSuperview];
    self.dismissedPlayerViewRef.transform = CGAffineTransformIdentity;
    self.dismissedPlayerViewRef.frame = self.oldFrame;
    [self.oldSuperView addSubview:self.dismissedPlayerViewRef];
}

@end
