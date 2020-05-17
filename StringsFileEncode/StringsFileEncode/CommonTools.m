//
//  CommonTools.m
//  PlistTool
//
//  Created by dayan on 2020/4/28.
//  Copyright © 2020 dayan. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools

+ (instancetype)sharedInstance {
    static CommonTools *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        sharedInstance = [[CommonTools alloc] init];
    });
    return sharedInstance;
}

-(NSString *)getFileString{
    printf("请输入文件地址：");
    char *filetring = malloc(sizeof(char) * 200);
    scanf("%s",filetring);
    printf("输入地址是：%s",filetring);
    //转化成字符串
    NSString *fileStr = [NSString stringWithFormat:@"%s",filetring];
    return fileStr;
}

//选择加密方式
- (NSString *)selectCodeType:(CodeType)codeType code:(NSString *)code{
    if(codeType == CodeTypeEncode){
        //加密
        return [self encode:code];
    }else{
        //解密
        return [self dencode:code];
    }
    return @"";
}

//加密
- (NSString *)encode:(NSString *)string
{
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}
//解密
- (NSString *)dencode:(NSString *)base64String
{
    //NSData *base64data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

-(void)scanfCodeType{
    //判断是解密还是什么
    int codeType = -1;
    do {
        printf("请选择加密/解密");
        printf("\n");
        printf("加密请输入0  解密请输入1 其他数退出:");
        printf("\n");
        scanf("%d",&codeType);
    } while (codeType < -1 || codeType > 2);
    
    if(codeType == 0){
        printf("已选择加密");
        printf("\n");
        [CommonTools sharedInstance].codeType = CodeTypeEncode;
    }else if (codeType == 1){
        printf("已选择解密");
        printf("\n");
        [CommonTools sharedInstance].codeType = CodeTypeDencode;
    }else{
        printf("已经退出程序");
        printf("\n");
        exit(0);
    }
}

//封装保存操作
-(void)saveDesktopWithFileType:(NSString *)fileType data:(id)data{
    NSString *deskFile = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    printf("准备保存到桌面...\n");
    printf("请输入文件名称\n");
    char *filetring = malloc(sizeof(char) * 100);
    scanf("%s",filetring);
    deskFile = [NSString stringWithFormat:@"%@/%s.%@",deskFile,filetring,fileType];
    BOOL success = [data writeToFile:deskFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if(success){
        //完成
        printf("完成！！！！\n");
        printf("保存到桌面\n");
    }else{
        printf("操作失败\n");
    }
}
@end
