//
// RCStringMaskView.m
//
// Copyright (c) 2013 Rich Cameron (rcameron.co)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Based on StackOverflow posting: http://stackoverflow.com/questions/8467141/ios-how-to-achieve-emboss-effect-for-the-text-on-uilabel

#import "RCDebossedLabel.h"

static UIColor *defaultTextColor    = nil;
static UIFont  *defaultFont         = nil;
static UIColor *defaultShadowColor  = nil;

@implementation RCDebossedLabel
{
  UIColor   *_textColor;
  NSString  *_text;
  UIFont    *_font;
  UIColor   *_shadowColor;
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Initalize class method
////////////////////////////////////////////////////////
+ (void)initialize
{
  if (self == [RCDebossedLabel class]) {
    defaultTextColor = [UIColor blackColor];
    defaultFont = [UIFont systemFontOfSize:17.f];
    defaultShadowColor = [UIColor colorWithWhite:0.f alpha:0.3f];
  }
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Init
////////////////////////////////////////////////////////
- (id)initWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font shadowColor:(UIColor *)shadowColor
{
  // Calculate frame size based on font
  CGSize frameSize = [text sizeWithFont:font];
  CGRect frame = {{0,0}, frameSize};
  self = [super initWithFrame:frame];

  if (!self)
    return nil;

  _text = text;
  _textColor = textColor;
  _font = font;
  _shadowColor = shadowColor;
  
  [self _RCStringMaskView_commonInit];
  
  return self;
}

////////////////////////////////////////////////////////
- (id)initWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
  return [self initWithText:text textColor:textColor font:font shadowColor:defaultShadowColor];
}

////////////////////////////////////////////////////////
- (id)initWithText:(NSString *)text
{
  // since the text color is black, make shadow color lighter
  
  return [self initWithText:text textColor:defaultTextColor font:defaultFont shadowColor:[UIColor colorWithWhite:1.f alpha:0.3f]];
}

////////////////////////////////////////////////////////
- (void)_RCStringMaskView_commonInit
{
  [self addTextAndShadowWithMask:[self imageMask] invertedMask:[self invertedImageMask]];
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Masking
////////////////////////////////////////////////////////
- (UIImage *)imageMask
{
  return [self imageMaskInverted:NO];
}

////////////////////////////////////////////////////////
- (UIImage *)invertedImageMask
{
  return [self imageMaskInverted:YES];
}

////////////////////////////////////////////////////////
- (UIImage *)imageMaskInverted:(BOOL)inverted
{
  CGSize frameSize = self.frame.size;
  CGRect rect = {CGPointZero, frameSize};
  CGFloat scale = [[UIScreen mainScreen] scale];
  CGColorSpaceRef grayScale = CGColorSpaceCreateDeviceGray();
  CGContextRef gc = CGBitmapContextCreate(NULL, frameSize.width * scale, frameSize.height * scale, 8, frameSize.width * scale, grayScale, kCGImageAlphaNone);
  
  CGContextScaleCTM(gc, scale, scale);
  CGColorSpaceRelease(grayScale);
  
  UIGraphicsPushContext(gc);
  {
    if (inverted)
      [[UIColor whiteColor] set];
    else
      [[UIColor blackColor] set];
    
    CGContextFillRect(gc, rect);
    
    if (inverted)
      [[UIColor blackColor] set];
    else
      [[UIColor whiteColor] set];
    
    [_text drawInRect:rect withFont:_font];
  }
  UIGraphicsPopContext();
  
  CGImageRef imageRef = CGBitmapContextCreateImage(gc);
  CGContextRelease(gc);
  
  UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationDownMirrored];
  CGImageRelease(imageRef);
  
  return image;
}

////////////////////////////////////////////////////////
- (UIImage *)transparentImageWithMask:(UIImage *)mask
{
  CGSize frameSize = self.frame.size;
  CGRect rect = {CGPointZero, frameSize};
  UIGraphicsBeginImageContextWithOptions(frameSize, NO, 0);
  [[UIColor clearColor] set];
  UIRectFill(rect);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextClipToMask(context, rect, mask.CGImage);
  [[UIColor blackColor] set];
  UIRectFill(rect);
  
  UIImage *clearImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return clearImage;
}

////////////////////////////////////////////////////////
- (void)addTextAndShadowWithMask:(UIImage *)mask invertedMask:(UIImage *)invertedMask
{
  UIImage *clearImage = [self transparentImageWithMask:invertedMask];
  
  CGSize frameSize = self.frame.size;
  CGRect rect = {CGPointZero, frameSize};
  UIGraphicsBeginImageContextWithOptions(frameSize, NO, 0);

  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextClipToMask(context, rect, mask.CGImage);
  
  [_textColor set];
  UIRectFill(rect);
  
  CGContextSetShadowWithColor(context, (CGSize){0,0}, 4.f, _shadowColor.CGColor);
  
  [clearImage drawAtPoint:CGPointZero];
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [self addSubview:imageView];
}

////////////////////////////////////////////////////////
@end
