//
//  SPLPackage.h
//  SwiftPackageListObjc
//
//  Created by Felix Herrmann on 27.02.22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A package object in the package-list.json or package-list.plist.
@interface SPLPackage : NSObject

/// The name of the package.
@property(nonatomic, readonly) NSString *name;

/// The version of the package.
///
/// Could be nil if the package's dependency-rule is branch or commit.
@property(nonatomic, readonly, nullable) NSString *version;

/// The name of the branch.
///
/// Could be nil if the package's dependency-rule is version or commit.
@property(nonatomic, readonly, nullable) NSString *branch;

/// The exact revision/commit.
///
/// This is always present, regardless if the package's dependency-rule is version or branch.
@property(nonatomic, readonly) NSString *revision;

/// The URL to the git-repository.
@property(nonatomic, readonly) NSURL *repositoryURL;

/// The license text.
///
/// This is always present if the --requires-license flag is parsed on command execution.
@property(nonatomic, readonly, nullable) NSString *license;

- (instancetype)initWithName:(NSString *)name
                     version:(nullable NSString *)version
                      branch:(nullable NSString *)branch
                    revision:(NSString *)revision
               repositoryURL:(NSURL *)repositoryURL
                     license:(nullable NSString *)license;

@end

NS_ASSUME_NONNULL_END
