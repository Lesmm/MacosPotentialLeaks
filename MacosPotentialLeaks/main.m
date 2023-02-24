//
//  main.m
//  MacosPotentialLeaks


#import <Cocoa/Cocoa.h>

// https://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

@interface Dummy : NSObject <NSCopying>
@end

@implementation Dummy

- (id)copyWithZone:(NSZone *)zone {
    return [[Dummy alloc] init];
}

- (id)clone {
    return [[Dummy alloc] init];
}

- (id)cloneCopy {
    return [self copy];
}

@end

void CopyDummy(Dummy *dummy) {
    __unused Dummy *dummyClone = [dummy copy];
}

void CloneDummy(Dummy *dummy) {
    __unused Dummy *dummyClone = [dummy clone];
}

void CopyDummyWithLeak(Dummy *dummy, SEL copySelector) {
    __unused Dummy *dummyClone = [dummy performSelector:copySelector];
}

void CloneDummyWithoutLeak(Dummy *dummy, SEL cloneSelector) {
    __unused Dummy *dummyClone = [dummy performSelector:cloneSelector];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        Dummy *dummy = [[Dummy alloc] init];
        for (int i = 0; i < 10; i++) {
            @autoreleasepool {
//                [dummy copy];
//                CopyDummy(dummy);
//                CloneDummy(dummy);
//                CloneDummyWithoutLeak(dummy, @selector(clone));
//                CloneDummyWithoutLeak(dummy, @selector(cloneCopy));
                
                CopyDummyWithLeak(dummy, @selector(copy));
                [NSThread sleepForTimeInterval:1];
            }
        }
    }
    return NSApplicationMain(argc, argv);
}
