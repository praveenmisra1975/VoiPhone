/**
 *  Siphon SIP-VoIP for iPhone and iPod Touch
 *  Copyright (C) 2008-2010 Samuel <samuelv0304@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#import "SettingController.h"
#import "InAppSettings.h"




@implementation SettingController

@synthesize phoneCallDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
  {
   
      // Initialization code
      self.title = @"Setting";
      self.tabBarItem.title = @"Settings";
      self.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

    _addUserButton =[[UIButton alloc] initWithFrame:
                CGRectMake(20.0f, 100.0f, 275.0f, 64.0f)];
    _addUserButton.enabled = true;
    
    _addUserButton.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
   
  [_addUserButton setTitle:@"Add SIP Account" forState:UIControlStateNormal];
  [_addUserButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  [_addUserButton setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
  [_addUserButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [_addUserButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
    [_addUserButton setBackgroundImage:[UIImage imageNamed:@"lcd_top_simple.png"]
                 forState: UIControlStateNormal];
    
   


  [_addUserButton addTarget:self action:@selector(settingButtonPressed:)
               forControlEvents:UIControlEventTouchDown];
    
    [_addUserButton setBackgroundColor:[UIColor darkGrayColor]];
 
  [view addSubview:_addUserButton];

  self.view = view;
  [view release];
}

- (void)settingButtonPressed:(UIButton*)button
{
    InAppSettingsModalViewController *settings = [[InAppSettingsModalViewController alloc] init];
        [self presentModalViewController:settings animated:YES];
        [settings release];
}

- (void)dealloc
{
  [_addUserButton release];
  

    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    }







@end

