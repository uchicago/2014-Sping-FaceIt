//
//  ViewController.m
//  FaceIt
//
//  Created by T. Andrew Binkowski on 5/8/13.
//
#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

///-----------------------------------------------------------------------------
#pragma mark - Buttons
///-----------------------------------------------------------------------------
- (IBAction)tapFindFace:(UIButton *)sender
{
    self.faceImageView.hidden = NO;
    self.kidsImageView.hidden = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIImage *image = [[CIImage alloc] initWithImage:self.faceImageView.image];
        
        NSString *accuracy = CIDetectorAccuracyHigh;
        NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
        NSArray *features = [detector featuresInImage:image];
        NSLog(@"Feature:%@",features);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawImageAnnotatedWithFeatures:features imageView:self.faceImageView];
        });
    });
}

- (IBAction)tapChallenge:(UIButton *)sender
{
    self.faceImageView.hidden = YES;
    self.kidsImageView.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIImage *image = [[CIImage alloc] initWithImage:self.kidsImageView.image];
        
        NSString *accuracy = CIDetectorAccuracyHigh;
        NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
        NSArray *features = [detector featuresInImage:image];
        NSLog(@"Feature:%@",features);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawImageAnnotatedWithFeatures:features imageView:self.kidsImageView];
        });
    });
}

///-----------------------------------------------------------------------------
#pragma mark - Draw Features
///-----------------------------------------------------------------------------
- (void)drawImageAnnotatedWithFeatures:(NSArray *)features imageView:(UIImageView*)imageView
{
    UIImage *faceImage = imageView.image;
    
    UIGraphicsBeginImageContextWithOptions(faceImage.size, YES, 0);
    [faceImage drawInRect:imageView.bounds];
    
    // Get image context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip Context
    CGContextTranslateCTM(context, 0, imageView.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0) {
        // Loaded 2x image, scale context to 50%
        CGContextScaleCTM(context, 0.5, 0.5);
    }
    
    for (CIFaceFeature *feature in features) {
        NSLog(@"%@",feature);
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2.0f * scale);
        CGContextAddRect(context, feature.bounds);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        // Set red feature color
        CGContextSetRGBFillColor(context, 1.0f, 0.0f, 0.0f, 0.4f);
        
        if (feature.hasLeftEyePosition) {
            [self drawFeatureInContext:context atPoint:feature.leftEyePosition];
        }
        
        if (feature.hasRightEyePosition) {
            [self drawFeatureInContext:context atPoint:feature.rightEyePosition];
        }
        
        if (feature.hasMouthPosition) {
            [self drawFeatureInContext:context atPoint:feature.mouthPosition];
        }
    }
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(imageView.image);
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
}

- (void)drawFeatureInContext:(CGContextRef)context atPoint:(CGPoint)featurePoint
{
    CGFloat radius = 20.0f * [UIScreen mainScreen].scale;
    CGContextAddArc(context, featurePoint.x, featurePoint.y, radius, 0, M_PI * 2, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
