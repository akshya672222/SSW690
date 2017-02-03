//
//  GlobalFunction.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 01/02/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit


class GlobalFunction{
    
//    class func numberOfLinesForLabel(label : UILabel) -> Int {
//        return 0;
//    }
//    
//    class func rectForLabel(label : UILabel) -> CGRect{
//     
//        let maxLabelSize = CGSize(width: 2000, height: 2000);
//        
//        let lblText = label.text;
//        let lblText_String = lblText as NSString;
//        
//        var rect = ((lblText_String).boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesFontLeading, attributes:[NSFontAttributeName: label.font], context: nil));
//        
//    }
    
}

//+(CGRect)rectForLabel:(UILabel *)label{
//    
//    CGSize maximumLabelSize2;
//    
//    maximumLabelSize2 = CGSizeMake(CGFLOAT_MAX_WIDTH,CGFLOAT_MAX_HEIGHT);
//    
//    CGRect r = [label.text boundingRectWithSize:maximumLabelSize2
//        options:NSStringDrawingUsesFontLeading
//        attributes:@{NSFontAttributeName:label.font}
//    context:nil];
//    return r;
//}
//
//
//+(CGFloat)heightForWidth:(CGFloat)width usingFont:(UIFont *)font forLabel:(UILabel *)lbl{
//    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
//    CGSize labelSize = (CGSize){width, CGFLOAT_MAX_HEIGHT};
//    CGRect r = [lbl.text boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
//    return r.size.height;
//}
//
//+(void)createShadowOnView:(UIView *)view color:(UIColor *)color width:(CGFloat)width height:(CGFloat)height shadowOpacity:(CGFloat)shadowOpacity andShadowRadius:(CGFloat)radius{
//    
//    view.layer.masksToBounds = NO;
//    view.layer.shadowColor = color.CGColor;
//    view.layer.shadowOffset = CGSizeMake(width,height);
//    view.layer.shadowOpacity = shadowOpacity;
//    [view.layer setShadowRadius:radius];
//    
//}
//
//+(void)roundCornerOfView:(UIView *)view cornerRadius:(CGFloat)cornerRadius{
//    view.layer.cornerRadius = cornerRadius;
//    view.layer.masksToBounds = NO;
//    
//}
//
//+(void)addborderTo:(UIView *)view withColor:(UIColor *)color andWidth:(CGFloat)width{
//    
//    view.layer.borderWidth = width;
//    view.layer.borderColor = color.CGColor;
//    
//}
