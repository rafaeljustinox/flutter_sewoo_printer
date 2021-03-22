#import "SewooPrinterPlugin.h"
#if __has_include(<sewoo_printer/sewoo_printer-Swift.h>)
#import <sewoo_printer/sewoo_printer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sewoo_printer-Swift.h"
#endif

@implementation SewooPrinterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSewooPrinterPlugin registerWithRegistrar:registrar];
}
@end
