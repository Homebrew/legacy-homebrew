class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-239.4.tar.gz"
  sha256 "c76eacb0863669d68538173ff261cb3afe302863d5c3b2287dc6816eb6a7e71f"

  bottle :unneeded

  keg_only :provided_by_osx

  # Use Tiger-style availability macros
  patch :DATA if MacOS.version < :leopard

  def install
    include.install Dir["include/*"]
  end
end

__END__
diff --git a/include/dlfcn.h b/include/dlfcn.h
index bcb0c09..ab77069 100644
--- a/include/dlfcn.h
+++ b/include/dlfcn.h
@@ -58,7 +58,7 @@ extern void * dlopen(const char * __path, int __mode);
 extern void * dlsym(void * __handle, const char * __symbol);
 
 #if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
-extern bool dlopen_preflight(const char* __path) __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);
+extern bool dlopen_preflight(const char* __path) __attribute__((unavailable));
 #endif /* not POSIX */
 
 
diff --git a/include/dlfcn.h b/include/dlfcn.h
index ab77069..60557d2 100644
--- a/include/dlfcn.h
+++ b/include/dlfcn.h
@@ -38,7 +38,7 @@ extern "C" {
 
 #if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
 #include <stdbool.h>
-#include <Availability.h>
+#include <AvailabilityMacros.h>
 /*
  * Structure filled in by dladdr().
  */
diff --git a/include/mach-o/dyld.h b/include/mach-o/dyld.h
index 642ca42..3436d81 100644
--- a/include/mach-o/dyld.h
+++ b/include/mach-o/dyld.h
@@ -29,7 +29,7 @@
 #include <stdbool.h>
 
 #include <mach-o/loader.h>
-#include <Availability.h>
+#include <AvailabilityMacros.h>
 
 #if __cplusplus
 extern "C" {
@@ -44,10 +44,10 @@ extern "C" {
  * will return the mach_header and name of an image, given an address in 
  * the image. dladdr() is thread safe.
  */
-extern uint32_t                    _dyld_image_count(void)                              __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
-extern const struct mach_header*   _dyld_get_image_header(uint32_t image_index)         __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
-extern intptr_t                    _dyld_get_image_vmaddr_slide(uint32_t image_index)   __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
-extern const char*                 _dyld_get_image_name(uint32_t image_index)           __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
+extern uint32_t                    _dyld_image_count(void)                              AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern const struct mach_header*   _dyld_get_image_header(uint32_t image_index)         AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern intptr_t                    _dyld_get_image_vmaddr_slide(uint32_t image_index)   AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern const char*                 _dyld_get_image_name(uint32_t image_index)           AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
 
 /*
@@ -58,8 +58,8 @@ extern const char*                 _dyld_get_image_name(uint32_t image_index)
  * _dyld_register_func_for_remove_image() is called after any terminators in an image are run
  * and before the image is un-memory-mapped.
  */
-extern void _dyld_register_func_for_add_image(void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide))    __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
-extern void _dyld_register_func_for_remove_image(void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide)) __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
+extern void _dyld_register_func_for_add_image(void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide))    AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern void _dyld_register_func_for_remove_image(void (*func)(const struct mach_header* mh, intptr_t vmaddr_slide)) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
 
 /*
@@ -67,7 +67,7 @@ extern void _dyld_register_func_for_remove_image(void (*func)(const struct mach_
  * specifed by the libraryName.  The libraryName parameter would be "bar" for /path/libbar.3.dylib and
  * "Foo" for /path/Foo.framework/Versions/A/Foo.  It returns -1 if no such library is loaded.
  */
-extern int32_t NSVersionOfRunTimeLibrary(const char* libraryName)            __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
+extern int32_t NSVersionOfRunTimeLibrary(const char* libraryName)            AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
 
 /*
@@ -76,7 +76,7 @@ extern int32_t NSVersionOfRunTimeLibrary(const char* libraryName)            __O
  * "Foo" for /path/Foo.framework/Versions/A/Foo.  It returns -1 if the main executable did not link
  * against the specified library.
  */
-extern int32_t NSVersionOfLinkTimeLibrary(const char* libraryName)           __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
+extern int32_t NSVersionOfLinkTimeLibrary(const char* libraryName)           AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
 
 /*
@@ -89,14 +89,14 @@ extern int32_t NSVersionOfLinkTimeLibrary(const char* libraryName)           __O
  * That is the path may be a symbolic link and not the real file. With deep directories the total bufsize 
  * needed could be more than MAXPATHLEN.
  */
-extern int _NSGetExecutablePath(char* buf, uint32_t* bufsize)                 __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_2_0);
+extern int _NSGetExecutablePath(char* buf, uint32_t* bufsize)                 AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER;
 
 
 
 /*
  * _dyld_moninit() is a private interface between dyld and libSystem.
  */
-extern void _dyld_moninit(void (*monaddition)(char *lowpc, char *highpc))    __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_2_0);
+extern void _dyld_moninit(void (*monaddition)(char *lowpc, char *highpc))    AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
 
 
@@ -141,23 +141,23 @@ typedef enum {
 typedef struct __NSObjectFileImage*  NSObjectFileImage;
 
 /* NSObjectFileImage can only be used with MH_BUNDLE files */
-extern NSObjectFileImageReturnCode NSCreateObjectFileImageFromFile(const char* pathName, NSObjectFileImage *objectFileImage)               __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern NSObjectFileImageReturnCode NSCreateObjectFileImageFromMemory(const void *address, size_t size, NSObjectFileImage *objectFileImage) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern bool                        NSDestroyObjectFileImage(NSObjectFileImage objectFileImage)                                             __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-
-extern uint32_t     NSSymbolDefinitionCountInObjectFileImage(NSObjectFileImage objectFileImage)                   __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern const char*  NSSymbolDefinitionNameInObjectFileImage(NSObjectFileImage objectFileImage, uint32_t ordinal)  __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern uint32_t     NSSymbolReferenceCountInObjectFileImage(NSObjectFileImage objectFileImage)                    __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern const char*  NSSymbolReferenceNameInObjectFileImage(NSObjectFileImage objectFileImage, uint32_t ordinal, bool *tentative_definition) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern bool         NSIsSymbolDefinedInObjectFileImage(NSObjectFileImage objectFileImage, const char* symbolName) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern void*        NSGetSectionDataInObjectFileImage(NSObjectFileImage objectFileImage, const char* segmentName, const char* sectionName, size_t *size) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern bool         NSHasModInitObjectFileImage(NSObjectFileImage objectFileImage)                                __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_3,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern NSObjectFileImageReturnCode NSCreateObjectFileImageFromFile(const char* pathName, NSObjectFileImage *objectFileImage)               AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern NSObjectFileImageReturnCode NSCreateObjectFileImageFromMemory(const void *address, size_t size, NSObjectFileImage *objectFileImage) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern bool                        NSDestroyObjectFileImage(NSObjectFileImage objectFileImage)                                             AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+
+extern uint32_t    NSSymbolDefinitionCountInObjectFileImage(NSObjectFileImage objectFileImage)                    AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern const char* NSSymbolDefinitionNameInObjectFileImage(NSObjectFileImage objectFileImage, uint32_t ordinal)   AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern uint32_t    NSSymbolReferenceCountInObjectFileImage(NSObjectFileImage objectFileImage)                     AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern const char* NSSymbolReferenceNameInObjectFileImage(NSObjectFileImage objectFileImage, uint32_t ordinal, bool *tentative_definition) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern bool        NSIsSymbolDefinedInObjectFileImage(NSObjectFileImage objectFileImage, const char* symbolName)  AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern void*       NSGetSectionDataInObjectFileImage(NSObjectFileImage objectFileImage, const char* segmentName, const char* sectionName, size_t *size) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern bool        NSHasModInitObjectFileImage(NSObjectFileImage objectFileImage)                                 AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;
 
 typedef struct __NSModule* NSModule;
-extern const char*  NSNameOfModule(NSModule m)         __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern const char*  NSLibraryNameForModule(NSModule m) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern const char*  NSNameOfModule(NSModule m)         AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern const char*  NSLibraryNameForModule(NSModule m) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
-extern NSModule NSLinkModule(NSObjectFileImage objectFileImage, const char* moduleName, uint32_t options) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern NSModule NSLinkModule(NSObjectFileImage objectFileImage, const char* moduleName, uint32_t options) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 #define NSLINKMODULE_OPTION_NONE                         0x0
 #define NSLINKMODULE_OPTION_BINDNOW                      0x1
 #define NSLINKMODULE_OPTION_PRIVATE                      0x2
@@ -165,27 +165,27 @@ extern NSModule NSLinkModule(NSObjectFileImage objectFileImage, const char* modu
 #define NSLINKMODULE_OPTION_DONT_CALL_MOD_INIT_ROUTINES  0x8
 #define NSLINKMODULE_OPTION_TRAILING_PHYS_NAME          0x10
 
-extern bool NSUnLinkModule(NSModule module, uint32_t options) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern bool NSUnLinkModule(NSModule module, uint32_t options) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 #define NSUNLINKMODULE_OPTION_NONE                  0x0
 #define NSUNLINKMODULE_OPTION_KEEP_MEMORY_MAPPED    0x1
 #define NSUNLINKMODULE_OPTION_RESET_LAZY_REFERENCES	0x2
 
 /* symbol API */
 typedef struct __NSSymbol* NSSymbol;
-extern bool     NSIsSymbolNameDefined(const char* symbolName)                                                    __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern bool     NSIsSymbolNameDefinedWithHint(const char* symbolName, const char* libraryNameHint)               __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern bool     NSIsSymbolNameDefinedInImage(const struct mach_header* image, const char* symbolName)            __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern NSSymbol NSLookupAndBindSymbol(const char* symbolName)                                                    __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern NSSymbol NSLookupAndBindSymbolWithHint(const char* symbolName, const char* libraryNameHint)               __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern NSSymbol NSLookupSymbolInModule(NSModule module, const char* symbolName)                                  __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern NSSymbol NSLookupSymbolInImage(const struct mach_header* image, const char* symbolName, uint32_t options) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern bool     NSIsSymbolNameDefined(const char* symbolName)                                                    AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern bool     NSIsSymbolNameDefinedWithHint(const char* symbolName, const char* libraryNameHint)               AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern bool     NSIsSymbolNameDefinedInImage(const struct mach_header* image, const char* symbolName)            AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern NSSymbol NSLookupAndBindSymbol(const char* symbolName)                                                    AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern NSSymbol NSLookupAndBindSymbolWithHint(const char* symbolName, const char* libraryNameHint)               AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern NSSymbol NSLookupSymbolInModule(NSModule module, const char* symbolName)                                  AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern NSSymbol NSLookupSymbolInImage(const struct mach_header* image, const char* symbolName, uint32_t options) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
 #define NSLOOKUPSYMBOLINIMAGE_OPTION_BIND            0x0
 #define NSLOOKUPSYMBOLINIMAGE_OPTION_BIND_NOW        0x1
 #define NSLOOKUPSYMBOLINIMAGE_OPTION_BIND_FULLY      0x2
 #define NSLOOKUPSYMBOLINIMAGE_OPTION_RETURN_ON_ERROR 0x4
-extern const char*  NSNameOfSymbol(NSSymbol symbol)    __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern void *       NSAddressOfSymbol(NSSymbol symbol) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern NSModule     NSModuleForSymbol(NSSymbol symbol) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern const char*  NSNameOfSymbol(NSSymbol symbol)    AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern void *       NSAddressOfSymbol(NSSymbol symbol) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern NSModule     NSModuleForSymbol(NSSymbol symbol) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
 /* error handling API */
 typedef enum {
@@ -213,7 +213,7 @@ typedef enum {
     NSOtherErrorInvalidArgs
 } NSOtherErrorNumbers;
 
-extern void NSLinkEditError(NSLinkEditErrors *c, int *errorNumber, const char** fileName, const char** errorString) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern void NSLinkEditError(NSLinkEditErrors *c, int *errorNumber, const char** fileName, const char** errorString) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
 typedef struct {
      void     (*undefined)(const char* symbolName);
@@ -222,28 +222,28 @@ typedef struct {
                           const char* fileName, const char* errorString);
 } NSLinkEditErrorHandlers;
 
-extern void NSInstallLinkEditErrorHandlers(const NSLinkEditErrorHandlers *handlers) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern void NSInstallLinkEditErrorHandlers(const NSLinkEditErrorHandlers *handlers) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 
-extern bool                      NSAddLibrary(const char* pathName)                   __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern bool                      NSAddLibraryWithSearching(const char* pathName)      __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern const struct mach_header* NSAddImage(const char* image_name, uint32_t options) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern bool                      NSAddLibrary(const char* pathName)                   AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern bool                      NSAddLibraryWithSearching(const char* pathName)      AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern const struct mach_header* NSAddImage(const char* image_name, uint32_t options) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
 #define NSADDIMAGE_OPTION_NONE                  	0x0
 #define NSADDIMAGE_OPTION_RETURN_ON_ERROR       	0x1
 #define NSADDIMAGE_OPTION_WITH_SEARCHING        	0x2
 #define NSADDIMAGE_OPTION_RETURN_ONLY_IF_LOADED 	0x4
 #define NSADDIMAGE_OPTION_MATCH_FILENAME_BY_INSTALLNAME	0x8
 
-extern bool _dyld_present(void)                                                              __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern bool _dyld_launched_prebound(void)                                                    __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern bool _dyld_all_twolevel_modules_prebound(void)                                        __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_3,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern void _dyld_bind_objc_module(const void* objc_module)                                  __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern bool _dyld_bind_fully_image_containing_address(const void* address)                   __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern bool _dyld_image_containing_address(const void* address)                              __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_3,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-extern void _dyld_lookup_and_bind(const char* symbol_name, void **address, NSModule* module) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern void _dyld_lookup_and_bind_with_hint(const char* symbol_name, const char* library_name_hint, void** address, NSModule* module) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);
-extern void _dyld_lookup_and_bind_fully(const char* symbol_name, void** address, NSModule* module) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
-
-extern const struct mach_header*  _dyld_get_image_header_containing_address(const void* address) __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_3,__MAC_10_5,__IPHONE_NA,__IPHONE_NA);
+extern bool _dyld_present(void)                                                              AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern bool _dyld_launched_prebound(void)                                                    AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern bool _dyld_all_twolevel_modules_prebound(void)                                        AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;
+extern void _dyld_bind_objc_module(const void* objc_module)                                  AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern bool _dyld_bind_fully_image_containing_address(const void* address)                   AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+extern bool _dyld_image_containing_address(const void* address)                              AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;
+extern void _dyld_lookup_and_bind(const char* symbol_name, void **address, NSModule* module) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern void _dyld_lookup_and_bind_with_hint(const char* symbol_name, const char* library_name_hint, void** address, NSModule* module) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4;
+extern void _dyld_lookup_and_bind_fully(const char* symbol_name, void** address, NSModule* module) AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER;
+
+extern const struct mach_header* _dyld_get_image_header_containing_address(const void* address) AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER;
 
 
 #if __cplusplus
diff --git a/include/mach-o/dyld_priv.h b/include/mach-o/dyld_priv.h
index 49d5775..2467b29 100644
--- a/include/mach-o/dyld_priv.h
+++ b/include/mach-o/dyld_priv.h
@@ -25,7 +25,7 @@
 #define _MACH_O_DYLD_PRIV_H_
 
 #include <stdbool.h>
-#include <Availability.h>
+#include <AvailabilityMacros.h>
 #include <mach-o/dyld.h>
 #include <mach-o/dyld_images.h>
 
