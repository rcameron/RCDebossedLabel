//
// RCMainViewController.m
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

#import "RCMainViewController.h"
#import "RCDebossedLabel.h"

@interface RCMainViewController ()

@end

@implementation RCMainViewController

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Init
////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (!self)
    return nil;
  
  return self;
}

////////////////////////////////////////////////////////
- (void)viewDidLoad
{
  [super viewDidLoad];

  RCDebossedLabel *maskView = [[RCDebossedLabel alloc] initWithText:@"Embossed" textColor:[UIColor redColor] font:[UIFont systemFontOfSize:64.f]];
  [self.view addSubview:maskView];
  
  [maskView setCenter:(CGPoint){self.view.frame.size.width * 0.5f, self.view.frame.size.height * 0.5f}];
}

////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////
@end
