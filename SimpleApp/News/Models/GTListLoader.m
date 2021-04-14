//
//  GTListLoader.m
//  SimpleApp
//
//  Created by 申凡 on 2021/4/13.
//

#import "GTListLoader.h"
#import <AFNetworking.h>
#import "GTListItem.h"
@implementation GTListLoader

- (void)GTListLoaderFinishBlock:(GTListLoaderFinishBlock)finishBlock {

	NSString *urlString = @"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e";
	NSURL *listURL = [NSURL URLWithString:urlString];
    
	NSURLSession *session = [NSURLSession sharedSession];
    
    //为了循环引用对self进行处理
	__weak typeof(self) weakSelf = self;
	NSURLSessionDataTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
	                                          __strong typeof (weakSelf) strongSelf = weakSelf;
	                                          NSError *jsonError;
	                                          id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

#warning 类型的检查
	                                          NSArray *dataArray = [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"result"])objectForKey:@"data"];
	                                          NSMutableArray *listItemArray = @[].mutableCopy;
	                                          for(NSDictionary *info in dataArray) {
							  GTListItem *listItem = [[GTListItem alloc]init];
							  [listItem configWithDictionary:info];
							  [listItemArray addObject:listItem];

						  }
	                                          [weakSelf _archiveListDataWithArray:listItemArray.copy];

	                                          //在这里调用block,将回调放到主线程中来
	                                          dispatch_async(dispatch_get_main_queue(), ^{
									 if (finishBlock) {
										 finishBlock(error ==nil,listItemArray.copy);
									 }
								 });

	                                          NSLog(@"");
					  }];

	[dataTask resume];

}

- (void)_archiveListDataWithArray:(NSArray<GTListItem *> *)array {
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachePath = [pathArray firstObject];

	NSFileManager *fileManager = [NSFileManager defaultManager];

	//创建文件夹
	NSString *dataPath = [cachePath stringByAppendingPathComponent:@"GTData"];
	NSError *creatError;
	[fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&creatError];

	//创建一个list文件地址存取数据
	NSString *listDataPath = [dataPath stringByAppendingPathComponent:@"list"];
	//NSData *listData = [@"abc" dataUsingEncoding:NSUTF8StringEncoding];

	//序列化list
    NSData *listData =  [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:nil];
	[fileManager createFileAtPath:listDataPath contents:listData attributes:nil];
    
    //读取相关文件
    NSData *readListData = [fileManager contentsAtPath:listDataPath];
    id unarchiveObj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [GTListItem class],nil] fromData:readListData error:nil];
    
    


	//查询文件
//	BOOL fileExist = [fileManager fileExistsAtPath:listDataPath];

	//删除文件
//    if(fileExist){
//        [fileManager removeItemAtPath:listDataPath error:nil];
//    }

	NSLog(@"");
// fileHandle追加文件数据˝
//	NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:listDataPath];
//
//	[fileHandle seekToEndOfFile];
//	[fileHandle writeData:[@"def" dataUsingEncoding:NSUTF8StringEncoding]];
//	[fileHandle synchronizeFile];
//	[fileHandle closeFile];

}

@end
