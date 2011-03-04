require 'formula'

class Lbdb <Formula
  url 'http://www.spinnaker.de/debian/lbdb_0.37.tar.gz'
  homepage 'http://www.spinnaker.de/lbdb/'
  md5 '877f19ed4f314f2db5d358341412f8d2'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
From d4c3f5faa27fa2046aec46a3b963e6817f01d0c8 Mon Sep 17 00:00:00 2001
From: diane@ghic.org <diane@motoko.(none)>
Date: Fri, 4 Sep 2009 16:26:08 -0700
Subject: [PATCH] Update ABQuery to work with newer versions of XCode

---
 ABQuery/ABQuery.pbproj/project.pbxproj    |  270 -----------------------------
 ABQuery/ABQuery.xcodeproj/project.pbxproj |  223 ++++++++++++++++++++++++
 Makefile.in                               |    4 +-
 3 files changed, 225 insertions(+), 272 deletions(-)
 delete mode 100644 ABQuery/ABQuery.pbproj/project.pbxproj
 create mode 100644 ABQuery/ABQuery.xcodeproj/project.pbxproj

diff --git a/ABQuery/ABQuery.pbproj/project.pbxproj b/ABQuery/ABQuery.pbproj/project.pbxproj
deleted file mode 100644
index 9f79c1b..0000000
--- a/ABQuery/ABQuery.pbproj/project.pbxproj
+++ /dev/null
@@ -1,270 +0,0 @@
-// !$*UTF8*$!
-{
-	archiveVersion = 1;
-	classes = {
-	};
-	objectVersion = 38;
-	objects = {
-		014CEA4F0018CE4811CA2923 = {
-			buildRules = (
-			);
-			buildSettings = {
-				COPY_PHASE_STRIP = NO;
-				OPTIMIZATION_CFLAGS = "-O0";
-			};
-			isa = PBXBuildStyle;
-			name = Development;
-		};
-		014CEA500018CE4811CA2923 = {
-			buildRules = (
-			);
-			buildSettings = {
-				COPY_PHASE_STRIP = YES;
-			};
-			isa = PBXBuildStyle;
-			name = Deployment;
-		};
-//010
-//011
-//012
-//013
-//014
-//030
-//031
-//032
-//033
-//034
-		034768E6FF38A76511DB9C8B = {
-			isa = PBXExecutableFileReference;
-			path = ABQuery;
-			refType = 3;
-		};
-//030
-//031
-//032
-//033
-//034
-//080
-//081
-//082
-//083
-//084
-		08FB7793FE84155DC02AAC07 = {
-			buildStyles = (
-				014CEA4F0018CE4811CA2923,
-				014CEA500018CE4811CA2923,
-			);
-			hasScannedForEncodings = 1;
-			isa = PBXProject;
-			mainGroup = 08FB7794FE84155DC02AAC07;
-			projectDirPath = "";
-			targets = (
-				08FB779FFE84155DC02AAC07,
-			);
-		};
-		08FB7794FE84155DC02AAC07 = {
-			children = (
-				08FB7795FE84155DC02AAC07,
-				C6859EA2029092E104C91782,
-				08FB779DFE84155DC02AAC07,
-				1AB674ADFE9D54B511CA2CBB,
-			);
-			isa = PBXGroup;
-			name = ABQuery;
-			refType = 4;
-		};
-		08FB7795FE84155DC02AAC07 = {
-			children = (
-				32A70AAB03705E1F00C91783,
-				08FB7796FE84155DC02AAC07,
-			);
-			isa = PBXGroup;
-			name = Source;
-			refType = 4;
-		};
-		08FB7796FE84155DC02AAC07 = {
-			fileEncoding = 4;
-			isa = PBXFileReference;
-			path = ABQuery.m;
-			refType = 4;
-		};
-		08FB779DFE84155DC02AAC07 = {
-			children = (
-				08FB779EFE84155DC02AAC07,
-				C6B583C60405C207001D6ECE,
-			);
-			isa = PBXGroup;
-			name = "External Frameworks and Libraries";
-			refType = 4;
-		};
-		08FB779EFE84155DC02AAC07 = {
-			isa = PBXFrameworkReference;
-			name = Foundation.framework;
-			path = /System/Library/Frameworks/Foundation.framework;
-			refType = 0;
-		};
-		08FB779FFE84155DC02AAC07 = {
-			buildPhases = (
-				08FB77A0FE84155DC02AAC07,
-				08FB77A1FE84155DC02AAC07,
-				08FB77A3FE84155DC02AAC07,
-				08FB77A5FE84155DC02AAC07,
-				C6859EA4029092FD04C91782,
-			);
-			buildSettings = {
-				FRAMEWORK_SEARCH_PATHS = "";
-				HEADER_SEARCH_PATHS = "";
-				INSTALL_PATH = "$(HOME)/bin";
-				LIBRARY_SEARCH_PATHS = "";
-				OTHER_CFLAGS = "";
-				OTHER_LDFLAGS = "";
-				OTHER_REZFLAGS = "";
-				PRECOMPILE_PREFIX_HEADER = YES;
-				PREFIX_HEADER = ABQuery_Prefix.h;
-				PRODUCT_NAME = ABQuery;
-				REZ_EXECUTABLE = YES;
-				SECTORDER_FLAGS = "";
-				WARNING_CFLAGS = "-Wmost -Wno-four-char-constants -Wno-unknown-pragmas";
-			};
-			dependencies = (
-			);
-			isa = PBXToolTarget;
-			name = ABQuery;
-			productInstallPath = "$(HOME)/bin";
-			productName = ABQuery;
-			productReference = 034768E6FF38A76511DB9C8B;
-		};
-		08FB77A0FE84155DC02AAC07 = {
-			buildActionMask = 2147483647;
-			files = (
-				32A70AAC03705E1F00C91783,
-			);
-			isa = PBXHeadersBuildPhase;
-			runOnlyForDeploymentPostprocessing = 0;
-		};
-		08FB77A1FE84155DC02AAC07 = {
-			buildActionMask = 2147483647;
-			files = (
-				08FB77A2FE84155DC02AAC07,
-			);
-			isa = PBXSourcesBuildPhase;
-			runOnlyForDeploymentPostprocessing = 0;
-		};
-		08FB77A2FE84155DC02AAC07 = {
-			fileRef = 08FB7796FE84155DC02AAC07;
-			isa = PBXBuildFile;
-			settings = {
-				ATTRIBUTES = (
-				);
-			};
-		};
-		08FB77A3FE84155DC02AAC07 = {
-			buildActionMask = 2147483647;
-			files = (
-				08FB77A4FE84155DC02AAC07,
-				C6B583C70405C207001D6ECE,
-			);
-			isa = PBXFrameworksBuildPhase;
-			runOnlyForDeploymentPostprocessing = 0;
-		};
-		08FB77A4FE84155DC02AAC07 = {
-			fileRef = 08FB779EFE84155DC02AAC07;
-			isa = PBXBuildFile;
-			settings = {
-			};
-		};
-		08FB77A5FE84155DC02AAC07 = {
-			buildActionMask = 2147483647;
-			files = (
-			);
-			isa = PBXRezBuildPhase;
-			runOnlyForDeploymentPostprocessing = 0;
-		};
-//080
-//081
-//082
-//083
-//084
-//1A0
-//1A1
-//1A2
-//1A3
-//1A4
-		1AB674ADFE9D54B511CA2CBB = {
-			children = (
-				034768E6FF38A76511DB9C8B,
-			);
-			isa = PBXGroup;
-			name = Products;
-			refType = 4;
-		};
-//1A0
-//1A1
-//1A2
-//1A3
-//1A4
-//320
-//321
-//322
-//323
-//324
-		32A70AAB03705E1F00C91783 = {
-			fileEncoding = 4;
-			isa = PBXFileReference;
-			path = ABQuery_Prefix.h;
-			refType = 4;
-		};
-		32A70AAC03705E1F00C91783 = {
-			fileRef = 32A70AAB03705E1F00C91783;
-			isa = PBXBuildFile;
-			settings = {
-			};
-		};
-//320
-//321
-//322
-//323
-//324
-//C60
-//C61
-//C62
-//C63
-//C64
-		C6859EA2029092E104C91782 = {
-			children = (
-			);
-			isa = PBXGroup;
-			name = Documentation;
-			refType = 4;
-		};
-		C6859EA4029092FD04C91782 = {
-			buildActionMask = 8;
-			dstPath = /usr/share/man/man1/;
-			dstSubfolderSpec = 0;
-			files = (
-				C6B583DD0405DFD5001D6ECE,
-			);
-			isa = PBXCopyFilesBuildPhase;
-			runOnlyForDeploymentPostprocessing = 1;
-		};
-		C6B583C60405C207001D6ECE = {
-			isa = PBXFrameworkReference;
-			name = AddressBook.framework;
-			path = /System/Library/Frameworks/AddressBook.framework;
-			refType = 0;
-		};
-		C6B583C70405C207001D6ECE = {
-			fileRef = C6B583C60405C207001D6ECE;
-			isa = PBXBuildFile;
-			settings = {
-			};
-		};
-		C6B583DD0405DFD5001D6ECE = {
-			fileRef = 034768E6FF38A76511DB9C8B;
-			isa = PBXBuildFile;
-			settings = {
-			};
-		};
-	};
-	rootObject = 08FB7793FE84155DC02AAC07;
-}
diff --git a/ABQuery/ABQuery.xcodeproj/project.pbxproj b/ABQuery/ABQuery.xcodeproj/project.pbxproj
new file mode 100644
index 0000000..635f5f8
--- /dev/null
+++ b/ABQuery/ABQuery.xcodeproj/project.pbxproj
@@ -0,0 +1,223 @@
+// !$*UTF8*$!
+{
+	archiveVersion = 1;
+	classes = {
+	};
+	objectVersion = 45;
+	objects = {
+
+/* Begin PBXBuildFile section */
+		8DD76F9C0486AA7600D96B5E /* Foundation.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 08FB779EFE84155DC02AAC07 /* Foundation.framework */; };
+		8DD76F9F0486AA7600D96B5E /* ABQuery.1 in CopyFiles */ = {isa = PBXBuildFile; fileRef = C6859EA3029092ED04C91782 /* ABQuery.1 */; };
+		C48F82A51051931E00C24762 /* ABQuery.m in Sources */ = {isa = PBXBuildFile; fileRef = C48F82A41051931E00C24762 /* ABQuery.m */; };
+		C48F82AD1051935600C24762 /* AddressBook.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = C48F82AC1051935600C24762 /* AddressBook.framework */; };
+/* End PBXBuildFile section */
+
+/* Begin PBXCopyFilesBuildPhase section */
+		8DD76F9E0486AA7600D96B5E /* CopyFiles */ = {
+			isa = PBXCopyFilesBuildPhase;
+			buildActionMask = 8;
+			dstPath = /usr/share/man/man1/;
+			dstSubfolderSpec = 0;
+			files = (
+				8DD76F9F0486AA7600D96B5E /* ABQuery.1 in CopyFiles */,
+			);
+			runOnlyForDeploymentPostprocessing = 1;
+		};
+/* End PBXCopyFilesBuildPhase section */
+
+/* Begin PBXFileReference section */
+		08FB779EFE84155DC02AAC07 /* Foundation.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = Foundation.framework; path = /System/Library/Frameworks/Foundation.framework; sourceTree = "<absolute>"; };
+		8DD76FA10486AA7600D96B5E /* ABQuery */ = {isa = PBXFileReference; explicitFileType = "compiled.mach-o.executable"; includeInIndex = 0; path = ABQuery; sourceTree = BUILT_PRODUCTS_DIR; };
+		C48F82A31051931E00C24762 /* ABQuery_Prefix.h */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.h; name = ABQuery_Prefix.h; path = "ABQuery_Prefix.h"; sourceTree = SOURCE_ROOT; };
+		C48F82A41051931E00C24762 /* ABQuery.m */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.objc; name = ABQuery.m; path = "ABQuery.m"; sourceTree = SOURCE_ROOT; };
+		C48F82AC1051935600C24762 /* AddressBook.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = AddressBook.framework; path = /System/Library/Frameworks/AddressBook.framework; sourceTree = "<absolute>"; };
+		C6859EA3029092ED04C91782 /* ABQuery.1 */ = {isa = PBXFileReference; lastKnownFileType = text.man; path = ABQuery.1; sourceTree = "<group>"; };
+/* End PBXFileReference section */
+
+/* Begin PBXFrameworksBuildPhase section */
+		8DD76F9B0486AA7600D96B5E /* Frameworks */ = {
+			isa = PBXFrameworksBuildPhase;
+			buildActionMask = 2147483647;
+			files = (
+				8DD76F9C0486AA7600D96B5E /* Foundation.framework in Frameworks */,
+				C48F82AD1051935600C24762 /* AddressBook.framework in Frameworks */,
+			);
+			runOnlyForDeploymentPostprocessing = 0;
+		};
+/* End PBXFrameworksBuildPhase section */
+
+/* Begin PBXGroup section */
+		08FB7794FE84155DC02AAC07 /* ABQuery */ = {
+			isa = PBXGroup;
+			children = (
+				C48F82AC1051935600C24762 /* AddressBook.framework */,
+				08FB7795FE84155DC02AAC07 /* Source */,
+				C6859EA2029092E104C91782 /* Documentation */,
+				08FB779DFE84155DC02AAC07 /* External Frameworks and Libraries */,
+				1AB674ADFE9D54B511CA2CBB /* Products */,
+			);
+			name = ABQuery;
+			sourceTree = "<group>";
+		};
+		08FB7795FE84155DC02AAC07 /* Source */ = {
+			isa = PBXGroup;
+			children = (
+				C48F82A31051931E00C24762 /* ABQuery_Prefix.h */,
+				C48F82A41051931E00C24762 /* ABQuery.m */,
+			);
+			name = Source;
+			sourceTree = "<group>";
+		};
+		08FB779DFE84155DC02AAC07 /* External Frameworks and Libraries */ = {
+			isa = PBXGroup;
+			children = (
+				08FB779EFE84155DC02AAC07 /* Foundation.framework */,
+			);
+			name = "External Frameworks and Libraries";
+			sourceTree = "<group>";
+		};
+		1AB674ADFE9D54B511CA2CBB /* Products */ = {
+			isa = PBXGroup;
+			children = (
+				8DD76FA10486AA7600D96B5E /* ABQuery */,
+			);
+			name = Products;
+			sourceTree = "<group>";
+		};
+		C6859EA2029092E104C91782 /* Documentation */ = {
+			isa = PBXGroup;
+			children = (
+				C6859EA3029092ED04C91782 /* ABQuery.1 */,
+			);
+			name = Documentation;
+			sourceTree = "<group>";
+		};
+/* End PBXGroup section */
+
+/* Begin PBXNativeTarget section */
+		8DD76F960486AA7600D96B5E /* ABQuery */ = {
+			isa = PBXNativeTarget;
+			buildConfigurationList = 1DEB927408733DD40010E9CD /* Build configuration list for PBXNativeTarget "ABQuery" */;
+			buildPhases = (
+				8DD76F990486AA7600D96B5E /* Sources */,
+				8DD76F9B0486AA7600D96B5E /* Frameworks */,
+				8DD76F9E0486AA7600D96B5E /* CopyFiles */,
+			);
+			buildRules = (
+			);
+			dependencies = (
+			);
+			name = ABQuery;
+			productInstallPath = "$(HOME)/bin";
+			productName = ABQuery;
+			productReference = 8DD76FA10486AA7600D96B5E /* ABQuery */;
+			productType = "com.apple.product-type.tool";
+		};
+/* End PBXNativeTarget section */
+
+/* Begin PBXProject section */
+		08FB7793FE84155DC02AAC07 /* Project object */ = {
+			isa = PBXProject;
+			buildConfigurationList = 1DEB927808733DD40010E9CD /* Build configuration list for PBXProject "ABQuery" */;
+			compatibilityVersion = "Xcode 3.1";
+			hasScannedForEncodings = 1;
+			mainGroup = 08FB7794FE84155DC02AAC07 /* ABQuery */;
+			projectDirPath = "";
+			projectRoot = "";
+			targets = (
+				8DD76F960486AA7600D96B5E /* ABQuery */,
+			);
+		};
+/* End PBXProject section */
+
+/* Begin PBXSourcesBuildPhase section */
+		8DD76F990486AA7600D96B5E /* Sources */ = {
+			isa = PBXSourcesBuildPhase;
+			buildActionMask = 2147483647;
+			files = (
+				C48F82A51051931E00C24762 /* ABQuery.m in Sources */,
+			);
+			runOnlyForDeploymentPostprocessing = 0;
+		};
+/* End PBXSourcesBuildPhase section */
+
+/* Begin XCBuildConfiguration section */
+		1DEB927508733DD40010E9CD /* Debug */ = {
+			isa = XCBuildConfiguration;
+			buildSettings = {
+				ALWAYS_SEARCH_USER_PATHS = NO;
+				COPY_PHASE_STRIP = NO;
+				GCC_DYNAMIC_NO_PIC = NO;
+				GCC_ENABLE_FIX_AND_CONTINUE = YES;
+				GCC_MODEL_TUNING = G5;
+				GCC_OPTIMIZATION_LEVEL = 0;
+				GCC_PRECOMPILE_PREFIX_HEADER = NO;
+				INSTALL_PATH = /usr/local/bin;
+				PRODUCT_NAME = ABQuery;
+			};
+			name = Debug;
+		};
+		1DEB927608733DD40010E9CD /* Release */ = {
+			isa = XCBuildConfiguration;
+			buildSettings = {
+				ALWAYS_SEARCH_USER_PATHS = NO;
+				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
+				GCC_MODEL_TUNING = G5;
+				GCC_PRECOMPILE_PREFIX_HEADER = NO;
+				INSTALL_PATH = /usr/local/bin;
+				PRODUCT_NAME = ABQuery;
+			};
+			name = Release;
+		};
+		1DEB927908733DD40010E9CD /* Debug */ = {
+			isa = XCBuildConfiguration;
+			buildSettings = {
+				ARCHS = "$(ARCHS_STANDARD_32_64_BIT)";
+				GCC_C_LANGUAGE_STANDARD = gnu99;
+				GCC_OPTIMIZATION_LEVEL = 0;
+				GCC_WARN_ABOUT_RETURN_TYPE = YES;
+				GCC_WARN_UNUSED_VARIABLE = YES;
+				ONLY_ACTIVE_ARCH = YES;
+				PREBINDING = NO;
+				SDKROOT = macosx10.5;
+			};
+			name = Debug;
+		};
+		1DEB927A08733DD40010E9CD /* Release */ = {
+			isa = XCBuildConfiguration;
+			buildSettings = {
+				ARCHS = "$(ARCHS_STANDARD_32_64_BIT)";
+				GCC_C_LANGUAGE_STANDARD = gnu99;
+				GCC_WARN_ABOUT_RETURN_TYPE = YES;
+				GCC_WARN_UNUSED_VARIABLE = YES;
+				PREBINDING = NO;
+				SDKROOT = macosx10.5;
+			};
+			name = Release;
+		};
+/* End XCBuildConfiguration section */
+
+/* Begin XCConfigurationList section */
+		1DEB927408733DD40010E9CD /* Build configuration list for PBXNativeTarget "ABQuery" */ = {
+			isa = XCConfigurationList;
+			buildConfigurations = (
+				1DEB927508733DD40010E9CD /* Debug */,
+				1DEB927608733DD40010E9CD /* Release */,
+			);
+			defaultConfigurationIsVisible = 0;
+			defaultConfigurationName = Release;
+		};
+		1DEB927808733DD40010E9CD /* Build configuration list for PBXProject "ABQuery" */ = {
+			isa = XCConfigurationList;
+			buildConfigurations = (
+				1DEB927908733DD40010E9CD /* Debug */,
+				1DEB927A08733DD40010E9CD /* Release */,
+			);
+			defaultConfigurationIsVisible = 0;
+			defaultConfigurationName = Release;
+		};
+/* End XCConfigurationList section */
+	};
+	rootObject = 08FB7793FE84155DC02AAC07 /* Project object */;
+}
diff --git a/Makefile.in b/Makefile.in
index 85bd678..e62352e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -155,9 +155,9 @@ ABQuery/sym/ABQuery: ABQuery/pbxbuild.sh ABQuery/ABQuery.m
 
 ABQuery/pbxbuild.sh:
 	if [ "$(XCODEBUILD)" != "no" ]; then \
-		(cd ABQuery; xcodebuild -buildstyle Deployment; printf '#!/bin/sh\nmkdir ABQuery/sym\nEXE=ABQuery/build/ABQuery\nif test -x ABQuery/build/Deployment/ABQuery; then EXE=ABQuery/build/Deployment/ABQuery; fi\ncp $$EXE ABQuery/sym\n' > pbxbuild.sh; chmod a+x pbxbuild.sh) \
+		(cd ABQuery; xcodebuild -configuration Deployment; printf '#!/bin/sh\nmkdir ABQuery/sym\nEXE=ABQuery/build/Release/ABQuery\nif test -x ABQuery/build/Debug/ABQuery; then EXE=ABQuery/build/Debug/ABQuery; fi\ncp $$EXE ABQuery/sym\n' > pbxbuild.sh; chmod a+x pbxbuild.sh) \
 	else \
-		(cd ABQuery; pbxbuild -buildstyle Deployment export) \
+		(cd ABQuery; pbxbuild -configuration Deployment export) \
 	fi
 
 clean:
-- 
1.6.4.2

