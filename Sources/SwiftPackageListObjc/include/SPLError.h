//
//  SPLError.h
//  SwiftPackageListObjc
//
//  Created by Felix Herrmann on 28.02.22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Domain for all Swift Package List errors
NSErrorDomain const SPLErrorDomain;

/// The possible thrown errors of the SPLPackageList function.
NS_ERROR_ENUM(SPLErrorDomain, SPLErrorCode) {
    
    /// Couldn't find a package-list.json or package-list.plist file in the specified bundle.
    SPLErrorNoPackageList = 100,
};

NS_ASSUME_NONNULL_END
