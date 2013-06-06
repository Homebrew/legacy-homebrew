require 'formula'

class MountainLionOrNewer < Requirement
  fatal true
  satisfy MacOS.version >= :mountainlion

  def message
    "Terminal-notifier requires the Notification Center of OS X 10.8+."
  end
end

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/alloy/terminal-notifier/archive/1.4.2.tar.gz'
  sha1 'eaa201650be05ff10aecde03df7f0acb161eefd8'

  head 'https://github.com/alloy/terminal-notifier.git'

  depends_on :xcode
  depends_on MountainLionOrNewer

  def patches
    # Disable code signing because we don't have the cert of the dev.
    # However, terminal-notifier will not be able to open apps or URLs.
    DATA
  end

  def install
    system 'xcodebuild', "-project", "Terminal Notifier.xcodeproj",
                         "-target", "terminal-notifier",
                         "SYMROOT=build",
                         "-verbose"
    prefix.install Dir['build/Release/*']
    inner_binary = "#{prefix}/terminal-notifier.app/Contents/MacOS/terminal-notifier"
    bin.write_exec_script inner_binary
    chmod 0755, Pathname.new(bin+"terminal-notifier")
  end

  def caveats
    <<-EOS.undent
      Homebrew built terminal-notifier, but without an developer certificate
      from Apple, it will not be able to open URLs or execute commands when
      the user clicks on a notification.
    EOS
  end

end

__END__
diff --git a/Terminal Notifier.xcodeproj/project.pbxproj b/Terminal Notifier.xcodeproj/project.pbxproj
index 163020e..bc0597e 100644
--- a/Terminal Notifier.xcodeproj/project.pbxproj	
+++ b/Terminal Notifier.xcodeproj/project.pbxproj	
@@ -275,7 +275,6 @@
 		5199793415B1F92B003AFC57 /* Release */ = {
 			isa = XCBuildConfiguration;
 			buildSettings = {
-				CODE_SIGN_IDENTITY = "Developer ID Application: Fingertips B.V.";
 				COMBINE_HIDPI_IMAGES = YES;
 				GCC_PRECOMPILE_PREFIX_HEADER = YES;
 				GCC_PREFIX_HEADER = "Terminal Notifier/Terminal Notifier-Prefix.pch";
