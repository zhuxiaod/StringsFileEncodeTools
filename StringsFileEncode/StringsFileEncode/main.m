//
//  main.m
//  StringsFileEncode
//
//  Created by MissSunRise on 2020/5/17.
//  Copyright © 2020 MissSunRise. All rights reserved.
//

#import "CommonTools.h"
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //获取文件路径
        NSString *fileString = [[CommonTools sharedInstance] getFileString];
        printf("\n");
        //获取plist文件
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fileString];
        NSLog(@"dictKey:%@",dict.allKeys);
        
        //逻辑
        //创建写入文件用的字符串
        NSMutableString *fileDataString = [[NSMutableString alloc] initWithString:@""];
        //遍历建值对
        for (NSString *dictKey in dict.allKeys) {
            //转换成字符串
            //加密
            NSString *KeyEncodeStr = [[CommonTools sharedInstance] encode:[[CommonTools sharedInstance] encode:dictKey]];
            NSString *valueEncodeStr = [[CommonTools sharedInstance] encode:[[CommonTools sharedInstance] encode:dict[dictKey]]];
            NSString *lineString = [NSString stringWithFormat:@"\"%@\" = \"%@\";\n\n",KeyEncodeStr,valueEncodeStr];
            [fileDataString appendString:lineString];
        }
        NSLog(@"%@",fileDataString);
        
        [[CommonTools sharedInstance] saveDesktopWithFileType:@"strings" data:fileDataString];
      
    }
    return 0;
}


