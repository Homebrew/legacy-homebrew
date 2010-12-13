require 'formula'

class AquaLess <Formula
  url 'http://downloads.sourceforge.net/project/aqualess/AquaLess/1.6/AquaLess-1.6-src.tar.gz'
  homepage 'http://aqualess.sourceforge.net/'
  md5 '0d20fbda422538480abd18f4b298b7e0'

  def patches
    # aless ordinarily wants to be installed to /usr/bin and asks to do so on first startup
    # the patch removes this check so it allows it to be installed anywhere
    DATA
  end

  def install
    system "xcodebuild", "-sdk", "macosx10.5"

    bin.install "build/Release/aless"
    prefix.install "build/Release/AquaLess.app"
  end

  def caveats
    "AquaLess.app installed to #{prefix}."
  end
end
__END__
diff --git a/AquaLess.xcodeproj/project.pbxproj b/AquaLess.xcodeproj/project.pbxproj
index def5b5f..0f41ca8 100644
--- a/AquaLess.xcodeproj/project.pbxproj
+++ b/AquaLess.xcodeproj/project.pbxproj
@@ -25,7 +25,6 @@
 		9DB8DEB20590C1370039D27C /* HexdumpInputParser.h in Headers */ = {isa = PBXBuildFile; fileRef = 9D028D010413A78700A81664 /* HexdumpInputParser.h */; };
 		9DB8DEB30590C1370039D27C /* RawTextInputParser.h in Headers */ = {isa = PBXBuildFile; fileRef = 9D4C893B0415118000A81664 /* RawTextInputParser.h */; };
 		9DB8DEB40590C1370039D27C /* ReadmeWindowController.h in Headers */ = {isa = PBXBuildFile; fileRef = 9DCE8DB50416511200A81608 /* ReadmeWindowController.h */; };
-		9DB8DEB50590C1370039D27C /* ToolInstaller.h in Headers */ = {isa = PBXBuildFile; fileRef = 9DC8FEA804191F9400A81608 /* ToolInstaller.h */; };
 		9DB8DEB60590C1370039D27C /* FindPanelController.h in Headers */ = {isa = PBXBuildFile; fileRef = 9D6B421D042DBD5500F86BBE /* FindPanelController.h */; };
 		9DB8DEB70590C1370039D27C /* AGRegex.h in Headers */ = {isa = PBXBuildFile; fileRef = 9DC53C8E045D6C1500C7B3CF /* AGRegex.h */; };
 		9DB8DEB80590C1370039D27C /* config.h in Headers */ = {isa = PBXBuildFile; fileRef = 9DC53C91045D6C1500C7B3CF /* config.h */; };
@@ -51,7 +50,6 @@
 		9DB8DECF0590C1370039D27C /* HexdumpInputParser.m in Sources */ = {isa = PBXBuildFile; fileRef = 9D028D020413A78700A81664 /* HexdumpInputParser.m */; };
 		9DB8DED00590C1370039D27C /* RawTextInputParser.m in Sources */ = {isa = PBXBuildFile; fileRef = 9D4C893C0415118000A81664 /* RawTextInputParser.m */; };
 		9DB8DED10590C1370039D27C /* ReadmeWindowController.m in Sources */ = {isa = PBXBuildFile; fileRef = 9DCE8DB60416511200A81608 /* ReadmeWindowController.m */; };
-		9DB8DED20590C1370039D27C /* ToolInstaller.m in Sources */ = {isa = PBXBuildFile; fileRef = 9DC8FEA904191F9400A81608 /* ToolInstaller.m */; };
 		9DB8DED30590C1370039D27C /* FindPanelController.m in Sources */ = {isa = PBXBuildFile; fileRef = 9D6B421E042DBD5500F86BBE /* FindPanelController.m */; };
 		9DB8DED40590C1370039D27C /* AGRegex.m in Sources */ = {isa = PBXBuildFile; fileRef = 9DC53C8F045D6C1500C7B3CF /* AGRegex.m */; };
 		9DB8DED50590C1370039D27C /* get.c in Sources */ = {isa = PBXBuildFile; fileRef = 9DC53C92045D6C1500C7B3CF /* get.c */; };
@@ -122,8 +120,6 @@
 		9DC53C95045D6C1500C7B3CF /* pcre.c */ = {isa = PBXFileReference; fileEncoding = 5; lastKnownFileType = sourcecode.c.c; name = pcre.c; path = regex/pcre.c; sourceTree = "<group>"; };
 		9DC53C96045D6C1500C7B3CF /* pcre.h */ = {isa = PBXFileReference; fileEncoding = 5; lastKnownFileType = sourcecode.c.h; name = pcre.h; path = regex/pcre.h; sourceTree = "<group>"; };
 		9DC53C97045D6C1500C7B3CF /* study.c */ = {isa = PBXFileReference; fileEncoding = 5; lastKnownFileType = sourcecode.c.c; name = study.c; path = regex/study.c; sourceTree = "<group>"; };
-		9DC8FEA804191F9400A81608 /* ToolInstaller.h */ = {isa = PBXFileReference; fileEncoding = 5; lastKnownFileType = sourcecode.c.h; path = ToolInstaller.h; sourceTree = "<group>"; };
-		9DC8FEA904191F9400A81608 /* ToolInstaller.m */ = {isa = PBXFileReference; fileEncoding = 5; lastKnownFileType = sourcecode.c.objc; path = ToolInstaller.m; sourceTree = "<group>"; };
 		9DC8FEAC0419293800A81608 /* Security.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = Security.framework; path = /System/Library/Frameworks/Security.framework; sourceTree = "<absolute>"; };
 		9DCE8DB50416511200A81608 /* ReadmeWindowController.h */ = {isa = PBXFileReference; fileEncoding = 5; lastKnownFileType = sourcecode.c.h; path = ReadmeWindowController.h; sourceTree = "<group>"; };
 		9DCE8DB60416511200A81608 /* ReadmeWindowController.m */ = {isa = PBXFileReference; fileEncoding = 5; lastKnownFileType = sourcecode.c.objc; path = ReadmeWindowController.m; sourceTree = "<group>"; };
@@ -233,8 +229,6 @@
 				9DA64EEB040C00E300A81664 /* aless.m */,
 				9D028CE2040FDF5900A81664 /* FontHelper.m */,
 				9D028CE1040FDF5900A81664 /* FontHelper.h */,
-				9DC8FEA904191F9400A81608 /* ToolInstaller.m */,
-				9DC8FEA804191F9400A81608 /* ToolInstaller.h */,
 			);
 			name = "Other Sources";
 			sourceTree = "<group>";
@@ -311,7 +305,6 @@
 				9DB8DEB20590C1370039D27C /* HexdumpInputParser.h in Headers */,
 				9DB8DEB30590C1370039D27C /* RawTextInputParser.h in Headers */,
 				9DB8DEB40590C1370039D27C /* ReadmeWindowController.h in Headers */,
-				9DB8DEB50590C1370039D27C /* ToolInstaller.h in Headers */,
 				9DB8DEB60590C1370039D27C /* FindPanelController.h in Headers */,
 				9DB8DEB70590C1370039D27C /* AGRegex.h in Headers */,
 				9DB8DEB80590C1370039D27C /* config.h in Headers */,
@@ -435,7 +428,6 @@
 				9DB8DECF0590C1370039D27C /* HexdumpInputParser.m in Sources */,
 				9DB8DED00590C1370039D27C /* RawTextInputParser.m in Sources */,
 				9DB8DED10590C1370039D27C /* ReadmeWindowController.m in Sources */,
-				9DB8DED20590C1370039D27C /* ToolInstaller.m in Sources */,
 				9DB8DED30590C1370039D27C /* FindPanelController.m in Sources */,
 				9DB8DED40590C1370039D27C /* AGRegex.m in Sources */,
 				9DB8DED50590C1370039D27C /* get.c in Sources */,
diff --git a/MyDocumentController.m b/MyDocumentController.m
index fcd3c9a..ce50199 100644
--- a/MyDocumentController.m
+++ b/MyDocumentController.m
@@ -22,7 +22,6 @@
 #import "MyDocumentController.h"
 #import "PagerDocument.h"
 #import "ReadmeWindowController.h"
-#import "ToolInstaller.h"
 #import "FontDisplayNameTransformer.h"
 #import "FontHelper.h"
 
@@ -91,9 +90,6 @@
                         @"The AquaLess application failed to register its communication port with the system. The command line tool will not be able to contact the application.",
                         @"OK", nil, nil);
     }
-    
-    // check for installation of command line tool
-    checkAndInstallTool();
 }
 
 - (void)openFileWithPath:(NSString *)filePath
diff --git a/ToolInstaller.h b/ToolInstaller.h
deleted file mode 100644
index 6455132..0000000
--- a/ToolInstaller.h
+++ /dev/null
@@ -1,22 +0,0 @@
-//
-// ToolInstaller.h
-//
-// AquaLess - a less-compatible text pager for Mac OS X
-// Copyright (c) 2003 Christoph Pfisterer
-//
-// This program is free software; you can redistribute it and/or
-// modify it under the terms of the GNU General Public License
-// as published by the Free Software Foundation; either version 2
-// of the License, or (at your option) any later version.
-//
-// This program is distributed in the hope that it will be useful,
-// but WITHOUT ANY WARRANTY; without even the implied warranty of
-// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-// GNU General Public License for more details.
-//
-// You should have received a copy of the GNU General Public License
-// along with this program; if not, write to the Free Software
-// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-//
-
-void checkAndInstallTool();
diff --git a/ToolInstaller.m b/ToolInstaller.m
deleted file mode 100644
index 7517250..0000000
--- a/ToolInstaller.m
+++ /dev/null
@@ -1,177 +0,0 @@
-//
-// ToolInstaller.m
-//
-// AquaLess - a less-compatible text pager for Mac OS X
-// Copyright (c) 2003 Christoph Pfisterer
-//
-// This program is free software; you can redistribute it and/or
-// modify it under the terms of the GNU General Public License
-// as published by the Free Software Foundation; either version 2
-// of the License, or (at your option) any later version.
-//
-// This program is distributed in the hope that it will be useful,
-// but WITHOUT ANY WARRANTY; without even the implied warranty of
-// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-// GNU General Public License for more details.
-//
-// You should have received a copy of the GNU General Public License
-// along with this program; if not, write to the Free Software
-// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-//
-
-#include <Security/Authorization.h>
-#include <Security/AuthorizationTags.h>
-
-#import "ToolInstaller.h"
-
-static const char *version_id_prefix = "|aless_version_id|";
-static const char version_id_terminator = '|';
-
-static NSString *getVersion(NSString *filePath);
-static int installTool(NSString *bundlePath, NSString *systemPath);
-
-
-void checkAndInstallTool()
-{
-  // first get the path of the copy of the tool inside out bundle
-  NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"aless" ofType:nil];
-  if (bundlePath == nil) {
-    NSRunCriticalAlertPanel(@"Application Damaged",
-                            @"The AquaLess application was damaged. Try re-installing it to fix this.",
-                            @"OK", nil, nil);
-    return;
-  }
-
-  // the installation location
-  NSString *systemPath = @"/usr/bin/aless";
-
-  // check the installation
-  NSFileManager *fm = [NSFileManager defaultManager];
-  if (![fm fileExistsAtPath:systemPath]) {
-    // not installed
-
-    // ask the user
-    int response =
-    NSRunAlertPanel(@"Command Line Tool Installation",
-                    @"To use AquaLess properly, the \"aless\" command line tool must be installed in /usr/bin. The process is automatic, but may require an administrator password.",
-                    @"Install", @"Cancel", nil);
-    if (response != NSAlertDefaultReturn)
-      return;
-
-    // do the installation
-    if (installTool(bundlePath, systemPath) == 0) {
-      NSRunInformationalAlertPanel(@"Installation Successful",
-                                   @"The \"aless\" command line tool is now installed.",
-                                   @"OK", nil, nil);
-    } else {
-      NSRunAlertPanel(@"Installation Failed",
-                      @"Installation of the command line tool failed. To try again, quit and re-launch AquaLess.",
-                      @"OK", nil, nil);
-    }
-
-  } else {
-    NSString *bundleVersion = getVersion(bundlePath);
-    NSString *systemVersion = getVersion(systemPath);
-    if (![systemVersion isEqualToString:bundleVersion]) {
-      // other version
-
-      // ask the user
-      int response =
-        NSRunAlertPanel(@"Command Line Tool Update",
-                        @"The copy of the \"aless\" command line tool on your system is outdated. It is strongly recommended to update it. The process is automatic, but may require an administrator password.",
-                        @"Update", @"Cancel", nil);
-      if (response != NSAlertDefaultReturn)
-        return;
-
-      // do the installation
-      if (installTool(bundlePath, systemPath) != 0) {
-        NSRunAlertPanel(@"Updating Failed",
-                        @"Updating the command line tool failed. To try again, quit and re-launch AquaLess.",
-                        @"OK", nil, nil);
-      }
-    }
-
-  }
-}
-
-
-static NSString *getVersion(NSString *filePath)
-{
-  NSString *version = @"";
-  NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
-
-  const char *data = [fileData bytes];
-  unsigned length = [fileData length];
-  const char *end = data + length;
-  const char *p = data;
-  while (p < end) {
-    p = memchr(p, version_id_prefix[0], end - p);
-    if (p == NULL)
-      break;
-    if (memcmp(p, version_id_prefix, strlen(version_id_prefix)) == 0) {
-      const char *version_id_start = p + strlen(version_id_prefix);
-      if (version_id_start < end) {
-        const char *q = memchr(version_id_start, version_id_terminator, end - version_id_start);
-        if (q != NULL && q < end) {
-          version = [NSString stringWithCString:version_id_start length:(q - version_id_start)];
-          break;
-        }
-      }
-    }
-    p++;
-  }
-
-  [fileData release];
-    return version;
-}
-
-static int installTool(NSString *bundlePath, NSString *systemPath)
-{
-  OSStatus myStatus;
-
-  // create authorization session
-  AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
-  AuthorizationRef myAuthorizationRef;
-  myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment,
-                                 myFlags, &myAuthorizationRef);
-  if (myStatus != errAuthorizationSuccess)
-    return myStatus;
-
-
-  do {
-
-    // add the execute right
-    {
-      AuthorizationItem myItems = { kAuthorizationRightExecute, 0, NULL, 0 };
-      AuthorizationRights myRights = { 1, &myItems };
-      myFlags = kAuthorizationFlagDefaults |
-        kAuthorizationFlagInteractionAllowed |
-        kAuthorizationFlagPreAuthorize |
-        kAuthorizationFlagExtendRights;
-      myStatus = AuthorizationCopyRights(myAuthorizationRef,
-                                         &myRights, NULL, myFlags, NULL );
-    }
-    if (myStatus != errAuthorizationSuccess)
-      break;
-
-    // call /usr/bin/install to do the dirty work
-    {
-      const char *myToolPath = "/usr/bin/install";
-      const char *myArguments[] = { "-o", "root", "-g", "wheel", "-m", "755", "-c", "-S",
-        [bundlePath UTF8String], [systemPath UTF8String], NULL };
-
-      myFlags = kAuthorizationFlagDefaults;
-      myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef,
-                                                    myToolPath, myFlags,
-                                                    (char **)myArguments,
-                                                    NULL);
-      // NOTE: The cast of myArguments avoids a compiler warning only.
-      //  The function actually expects a "const * char *", but the Obj-C
-      //  compiler somehow doesn't know about that...
-    }
-  } while (0);
-
-  AuthorizationFree(myAuthorizationRef, kAuthorizationFlagDefaults);
-
-  return myStatus;
-}
