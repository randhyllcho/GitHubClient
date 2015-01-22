//
//  ToUserDetailAnimationController.swift
//  GitHub
//
//  Created by RYAN CHRISTENSEN on 1/21/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class ToUserDetailAnimationController : NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.4
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as SearchUserViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    
    let containerView = transitionContext.containerView()
    
    let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems().first as NSIndexPath
    let cell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCell
    let snapShotOfCell = cell.imageView.snapshotViewAfterScreenUpdates(false)
    cell.imageView.hidden = true
    snapShotOfCell.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
    
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.alpha = 0
    toVC.userImageView.hidden = true
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapShotOfCell)
    
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1.0
      
      let frame = containerView.convertRect(toVC.userImageView.frame, fromView: toVC.view)
      snapShotOfCell.frame = frame
      
      
    }) { (finished) -> Void in
      toVC.userImageView.hidden = false
      cell.imageView.hidden = false
      snapShotOfCell.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
  }
  
}
