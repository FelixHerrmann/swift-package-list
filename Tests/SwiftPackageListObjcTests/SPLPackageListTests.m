//
//  SPLPackageListTests.m
//  SwiftPackageListObjcTests
//
//  Created by Felix Herrmann on 15.05.22.
//

#import <XCTest/XCTest.h>
@import SwiftPackageListObjc;

@interface SPLPackageListTests : XCTestCase

@end

@implementation SPLPackageListTests

- (void) testJSON {
    NSArray<SPLPackage *> *packages = SPLPackageListFromBundleWithFileName(SWIFTPM_MODULE_BUNDLE, @"example_1", nil);
    
    NSArray<NSString *> *expectedNames = @[@"swift-algorithms", @"swift-argument-parser", @"swift-collections", @"swift-numerics"];
    XCTAssertEqualObjects([packages valueForKey:@"name"], expectedNames);
    
    NSArray<NSString *> *expectedVersions = @[@"1.0.0", [NSNull null], [NSNull null], @"1.0.2"];
    XCTAssertEqualObjects([packages valueForKey:@"version"], expectedVersions);
    
    NSArray<NSString *> *expectedBranches = @[[NSNull null], [NSNull null], @"main", [NSNull null]];
    XCTAssertEqualObjects([packages valueForKey:@"branch"], expectedBranches);
    
    NSArray<NSString *> *expectedRevisions = @[@"b14b7f4c528c942f121c8b860b9410b2bf57825e", @"060d52364cf2a3e06b7adf0b17dbb7c33c77e1d3", @"108ac4fa4ef7f2622b97a1f5dd92a3e0c6857c60", @"0a5bc04095a675662cf24757cc0640aa2204253b"];
    XCTAssertEqualObjects([packages valueForKey:@"revision"], expectedRevisions);
    
    NSArray<NSString *> *expectedRepositoryURLs = @[@"https://github.com/apple/swift-algorithms", @"https://github.com/apple/swift-argument-parser", @"https://github.com/apple/swift-collections", @"https://github.com/apple/swift-numerics"];
    XCTAssertEqualObjects([packages valueForKey:@"repositoryURL"], expectedRepositoryURLs);
    
    NSArray<NSNumber *> *expectedLicenseLengths = @[@11751, @11751, @11751, @11751];
    XCTAssertEqualObjects([packages valueForKeyPath:@"license.length"], expectedLicenseLengths);
}

- (void) testPropertyList {
    NSArray<SPLPackage *> *packages = SPLPackageListFromBundleWithFileName(SWIFTPM_MODULE_BUNDLE, @"example_2", nil);
    
    NSArray<NSString *> *expectedNames = @[@"swift-algorithms", @"swift-argument-parser", @"swift-collections", @"swift-numerics"];
    XCTAssertEqualObjects([packages valueForKey:@"name"], expectedNames);
    
    NSArray<NSString *> *expectedVersions = @[@"1.0.0", [NSNull null], [NSNull null], @"1.0.2"];
    XCTAssertEqualObjects([packages valueForKey:@"version"], expectedVersions);
    
    NSArray<NSString *> *expectedBranches = @[[NSNull null], [NSNull null], @"main", [NSNull null]];
    XCTAssertEqualObjects([packages valueForKey:@"branch"], expectedBranches);
    
    NSArray<NSString *> *expectedRevisions = @[@"b14b7f4c528c942f121c8b860b9410b2bf57825e", @"060d52364cf2a3e06b7adf0b17dbb7c33c77e1d3", @"108ac4fa4ef7f2622b97a1f5dd92a3e0c6857c60", @"0a5bc04095a675662cf24757cc0640aa2204253b"];
    XCTAssertEqualObjects([packages valueForKey:@"revision"], expectedRevisions);
    
    NSArray<NSString *> *expectedRepositoryURLs = @[@"https://github.com/apple/swift-algorithms", @"https://github.com/apple/swift-argument-parser", @"https://github.com/apple/swift-collections", @"https://github.com/apple/swift-numerics"];
    XCTAssertEqualObjects([packages valueForKeyPath:@"repositoryURL.relative"], expectedRepositoryURLs);
    
    NSArray<NSNumber *> *expectedLicenseLengths = @[@11751, @11751, @11751, @11751];
    XCTAssertEqualObjects([packages valueForKeyPath:@"license.length"], expectedLicenseLengths);
}

- (void) testErrors {
    NSError *error;
    SPLPackageListFromBundleWithFileName(SWIFTPM_MODULE_BUNDLE, @"test", &error);
    
    XCTAssertEqual(error.code, SPLErrorNoPackageList);
}

@end
