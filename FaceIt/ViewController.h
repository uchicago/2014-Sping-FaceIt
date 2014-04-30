//
//  ViewController.h
//  FaceIt
//
//  Created by T. Andrew Binkowski on 5/8/13.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

///-----------------------------------------------------------------------------
/// @name Image Views
///-----------------------------------------------------------------------------
/** Image view for Obama */
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;

/** Image view for kids */
@property (weak, nonatomic) IBOutlet UIImageView *kidsImageView;

///-----------------------------------------------------------------------------
/// @name Buttons
///-----------------------------------------------------------------------------
/** Button action for find Obama */
- (IBAction)tapFindFace:(UIButton *)sender;

/** Button actions for find kids */
- (IBAction)tapChallenge:(UIButton *)sender;

@end
