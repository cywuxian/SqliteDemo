//
//  ViewController.h
//  SqliteDemo
//
//  Created by Yali on 14年10月24日.
//  Copyright (c) 2014年 morpheus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController
{
    sqlite3 *db;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *city;
@end

