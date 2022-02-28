//
//  SPLPackageList.h
//  SwiftPackageListObjc
//
//  Created by Felix Herrmann on 27.02.22.
//

#import <Foundation/Foundation.h>
#import "SPLPackage.h"

NS_ASSUME_NONNULL_BEGIN

/// This function reads the package-list.json or package-list.plist file in the specified bundle.
///
/// Make sure that the file is part of your project/target.
/// @param bundle The bundle where the file is stored.
/// @param errorPtr If an error occurs, upon return contains an NSError object with code SPLErrorCode that describes the problem.
/// @returns An array of SPLPackage objects or nil of an error occurred.
NSArray<SPLPackage *> *_Nullable SPLPackageListFromBundle(NSBundle *bundle, NSError **errorPtr);

/// This function reads the package-list.json or package-list.plist file in the main bundle.
///
/// Make sure that the file is part of your project/target.
/// @param errorPtr If an error occurs, upon return contains an NSError object with code SPLErrorCode that describes the problem.
/// @returns An array of SPLPackage objects or nil of an error occurred.
NSArray<SPLPackage *> *_Nullable SPLPackageList(NSError **errorPtr);

NS_ASSUME_NONNULL_END
