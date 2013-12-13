require 'formula'

class Setweblocthumb < Formula
  homepage 'http://hasseg.org/setWeblocThumb'
  url 'https://github.com/ali-rantakari/setWeblocThumb/archive/v0.9.9.tar.gz'
  sha1 '5c78c6b8fc22e122c549271f115fed8cdabd3174'

  def patches
    # removes self-updater code from setWeblocThumb.m, as well as
    # modifying Makefile to remove certain files from compilation
    DATA
  end

  def install
    system "rm",
           "HGCLIAutoUpdater.h",
           "HGCLIAutoUpdaterDelegate.h",
           "SetWeblocThumbAutoUpdaterDelegate.h",
           "HGCLIAutoUpdater.m",
           "HGCLIAutoUpdaterDelegate.m",
           "SetWeblocThumbAutoUpdaterDelegate.m"
    system "make"
    bin.install "setWeblocThumb"
  end

  def caveats; <<-EOS.undent
    You can use Launch Agents to watch a particular folder and have setWeblocThumb automatically operate periodically on that folder.

    setWeblocThumb -a <path>

      Create and automatically load a user-specific launch agent for <path> that
      runs this program each time the contents of <path> change

    setWeblocThumb -w

      List paths that are being watched by user-specific launch agents

    setWeblocThumb's self-updater code has been patched out by Homebrew, as we handle all updating of apps installed by Homebrew.

    setWeblocThumb is installed as written in all prior cases, but can be invoked in any case, e.g. setweblocthumb, SETWEBLOCTHUMB, setWeblocThumb, etc.
    EOS
  end

  test do
    system "#{bin}/setWeblocThumb"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 4d12c93..9090737 100644
--- a/Makefile
+++ b/Makefile
@@ -19,7 +19,7 @@ DEPLOYMENT_INCLUDES_DIR="./deployment-files"
 COMPILER=clang
 
 
-SOURCE_FILES=setWeblocThumb.m launchAgentGen.m MBBase64.m ANSIEscapeHelper.m HGCLIUtils.m HGCLIAutoUpdater.m HGCLIAutoUpdaterDelegate.m SetWeblocThumbAutoUpdaterDelegate.m
+SOURCE_FILES=setWeblocThumb.m launchAgentGen.m MBBase64.m ANSIEscapeHelper.m HGCLIUtils.m
 
 
 
diff --git a/setWeblocThumb.m b/setWeblocThumb.m
index c554b0d..c1c005a 100644
--- a/setWeblocThumb.m
+++ b/setWeblocThumb.m
@@ -29,8 +29,6 @@ under the License.
 #import "MBBase64.h"
 #import "imgBase64.m"
 #import "HGCLIUtils.h"
-#import "HGCLIAutoUpdater.h"
-#import "SetWeblocThumbAutoUpdaterDelegate.h"
 #import "launchAgentGen.h"
 
 
@@ -484,6 +482,10 @@ int main(int argc, char *argv[])
 		    @"%s -u\n"
 		    @"\n"
 		    @"  Check for updates (and optionally auto-update self)\n"
+		    @"  (Homebrew handles updating of apps, so\n"
+		    @"  we patched out updater code; the prior lines\n"
+		    @"  are for informational and documentation\n"
+		    @"  purposes only)\n"
 		    @"\n"
 		    @"Version %@\n"
 		    @"Copyright (c) 2009-2012 Ali Rantakari\n"
@@ -495,7 +497,6 @@ int main(int argc, char *argv[])
 		exit(0);
 	}
 	
-	BOOL arg_autoUpdate = NO;
 	BOOL arg_forceRun = NO;
 	BOOL arg_allowPlugins = NO;
 	BOOL arg_allowJava = NO;
@@ -507,9 +508,6 @@ int main(int argc, char *argv[])
 	
 	NSString *providedPath = [[NSString stringWithUTF8String:argv[argc-1]] stringByStandardizingPath];
 	
-	if (strcmp(argv[1], "-u") == 0)
-		arg_autoUpdate = YES;
-	
 	if (1 < argc)
 	{
 		int i;
@@ -543,19 +541,6 @@ int main(int argc, char *argv[])
 	}
 	
 	
-	if (arg_autoUpdate)
-	{
-		HGCLIAutoUpdater *autoUpdater = [[[HGCLIAutoUpdater alloc]
-			initWithAppName:@"setWeblocThumb"
-			currentVersionStr:versionNumberStr()
-			] autorelease];
-		SetWeblocThumbAutoUpdaterDelegate *autoUpdaterDelegate = [[[SetWeblocThumbAutoUpdaterDelegate alloc] init] autorelease];
-		autoUpdater.delegate = autoUpdaterDelegate;
-		
-		[autoUpdater checkForUpdatesWithUI];
-		return 0;
-	}
-	
 	if (arg_printLaunchAgentWatchPaths)
     {
         printLaunchAgentWatchPaths();
