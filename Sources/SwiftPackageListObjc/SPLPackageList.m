//
//  SPLPackageList.m
//  SwiftPackageListObjc
//
//  Created by Felix Herrmann on 27.02.22.
//

#import "SPLPackageList.h"
#import "SPLError.h"

#pragma mark - Helpers

NSArray<SPLPackage *> *SPLTransformArray(NSArray *array) {
    NSMutableArray<SPLPackage *> *packages = [[NSMutableArray alloc] init];
    for (NSDictionary *packageDict in array) {
        SPLPackage *package = [[SPLPackage alloc] initWithName:[packageDict valueForKey:@"package"]
                                                       version:[packageDict valueForKey:@"version"]
                                                        branch:[packageDict valueForKey:@"branch"]
                                                      revision:[packageDict valueForKey:@"revision"]
                                                 repositoryURL:[packageDict valueForKey:@"repositoryURL"]
                                                       license:[packageDict valueForKey:@"license"]];
        [packages addObject:package];
    }
    return packages;
}

#pragma mark - Package List

NSArray<SPLPackage *> *SPLPackageListFromBundle(NSBundle *bundle, NSError *__autoreleasing *errorPtr) {
    
    NSString *jsonPath = [bundle pathForResource:@"package-list" ofType:@"json"];
    if (jsonPath) {
        NSURL *jsonPathURL = [NSURL fileURLWithPath:jsonPath];
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonPathURL options:kNilOptions error:errorPtr];
        if (jsonData && [NSJSONSerialization isValidJSONObject:jsonData]) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:errorPtr];
            if (jsonObject) {
                return SPLTransformArray(jsonObject);
            }
        }
        return nil;
    }
    
    NSString *plistPath = [bundle pathForResource:@"package-list" ofType:@"plist"];
    if (plistPath) {
        NSURL *plistPathURL = [NSURL fileURLWithPath:plistPath];
        NSData *plistData = [NSData dataWithContentsOfURL:plistPathURL options:kNilOptions error:errorPtr];
        if (plistData && [NSPropertyListSerialization propertyList:plistData isValidForFormat:NSPropertyListXMLFormat_v1_0]) {
            NSArray *propertyList = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListMutableContainers format:nil error:errorPtr];
            if (propertyList) {
                return SPLTransformArray(propertyList);
            }
        }
        return nil;
    }
    
    if (errorPtr) {
        NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey: NSLocalizedString(@"Reading package list unsuccessful.", nil),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"There is no package-list file located in the bundle", nil),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the file is part of your project/target.", nil),
        };
        *errorPtr = [NSError errorWithDomain:SPLErrorDomain code:SPLErrorNoPackageList userInfo:userInfo];
    }
    return nil;
}

NSArray<SPLPackage *> *SPLPackageList(NSError *__autoreleasing *errorPtr) {
    return SPLPackageListFromBundle([NSBundle mainBundle], errorPtr);
}
