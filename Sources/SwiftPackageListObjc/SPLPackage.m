//
//  SPLPackage.m
//  SwiftPackageListObjc
//
//  Created by Felix Herrmann on 27.02.22.
//

#import "SPLPackage.h"

@implementation SPLPackage

- (instancetype)initWithIdentity:(NSString *)identity
                            name:(NSString *)name
                         version:(NSString *)version
                          branch:(NSString *)branch
                        revision:(NSString *)revision
                   repositoryURL:(NSURL *)repositoryURL
                         license:(NSString *)license {
    self = [super init];
    if (self) {
        _identity = identity;
        _name = name;
        _version = version;
        _branch = branch;
        _revision = revision;
        _repositoryURL = repositoryURL;
        _license = license;
    }
    return self;
}

@end
