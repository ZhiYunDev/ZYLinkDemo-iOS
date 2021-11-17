//
//  ViewController.h
//  FimicSDK
//
//  Created by Liao GJ on 2019/8/5.
//  Copyright © 2019 Liao GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

