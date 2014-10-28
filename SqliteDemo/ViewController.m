//
//  ViewController.m
//  SqliteDemo
//
//  Created by Yali on 14年10月24日.
//  Copyright (c) 2014年 morpheus. All rights reserved.
//

#import "ViewController.h"
#define DBNAME @"personinfo.sqlite"
#define TABLENAME @"personinfo"
#define NAME @"name"
#define AGE @"age"
#define CITY @"city"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int age =4,code = 6;
    int(^blockName)(int,int)=^(int newage,int newcode){
        return age+code;
    };
    
   int call =  blockName(age,code);
    NSLog(@"%d",call);
    age = 3,code = 5;
    int codename = blockName(age,code);
    NSLog(@"%d",codename);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)queryAction:(id)sender {
    //查询数据
    NSString *query = @"select * from personinfo";
    [self QuerySqlite:query];
    //limit查询
    NSString *limitQuery = @"select *from personinfo limit 2,8";//从第二行开始查询，找出符合条件的5条信息
    [self QuerySqlite:limitQuery];
}
//改变年龄为26的对象
- (IBAction)ChangAction:(id)sender {
    NSString *updataString = [NSString stringWithFormat:@"update %@ set age= 24 where age = 26",TABLENAME];
    [self execSqlite:updataString];
}
//删除年龄为26的数据
- (IBAction)DeleteAction:(id)sender {
    NSString *deleteString = [NSString stringWithFormat:@"delete from %@ where age = 26",TABLENAME];
    [self execSqlite:deleteString];
}

- (IBAction)SqlLiteAction:(id)sender {
    NSString *patch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@",DBNAME]];
    //开启数据库,如果打开失败则把数据源关闭,如果创建的数据库不存在则创建。
    if (sqlite3_open([patch UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
    }else
    {
        NSLog(@"创建数据库成功%@",patch);
    }
    //创建表单
    NSString *CreateTable = @"create table if not exists personinfo (name text,age text,city text)";
    [self execSqlite:CreateTable];
    //插入数据
    NSString *cell = [NSString stringWithFormat:@"insert into '%@'('%@','%@','%@')values('%@','%@','%@')",TABLENAME,NAME,AGE,CITY,_name.text,_age.text,_city.text];
    if ([self execSqlite:cell]) {
        NSLog(@"插入数据成功！");
    }
}
//创建表、增、删、改
- (BOOL)execSqlite:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String],nil, nil,&err)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"%s",err);
        return NO;
    }else
    {
        NSLog(@"语句执行成功");
        return YES;
    }
}

- (void)QuerySqlite:(NSString *)sql
{
    NSString *patch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@",DBNAME]];
    if (sqlite3_open([patch UTF8String], &db)==SQLITE_OK) {
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    char *name = (char*)sqlite3_column_text(statement, 0);
                    NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
                    int age = sqlite3_column_int(statement, 1);
                    char *address = (char*)sqlite3_column_text(statement,2);
                    NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
                    NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
            }
              sqlite3_close(db);
        }
        
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_name resignFirstResponder];
    [_age resignFirstResponder];
    [_city resignFirstResponder];
}
@end
