class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "http://ditaa.sourceforge.net/"
  url "https://github.com/stathissideris/ditaa/archive/v0.10.tar.gz"
  sha256 "82e49065d408cba8b323eea0b7f49899578336d566096c6eb6e2d0a28745d63b"

  depends_on :ant => :build
  depends_on :java

  # 0.10 Release didn't still calls itself 0.9
  # Reported upstream at https://github.com/stathissideris/ditaa/issues/14
  patch :DATA

  def install
    mkdir "bin"
    system "ant", "-buildfile", "build/release.xml", "release-jar"
    libexec.install "releases/ditaa0_10.jar"
    bin.write_jar_script libexec/"ditaa0_10.jar", "ditaa"
  end

  test do
    system "#{bin}/ditaa", "-help"
  end
end

__END__
diff -ur ditaa-0.10/build/release.xml ditaa-0.10.patched/build/release.xml
--- ditaa-0.10/build/release.xml
+++ ditaa-0.10.patched/build/release.xml
@@ -5,7 +5,7 @@
 	</description>
     
 	<property name="rootDir" value=".."/>
-	<property name="version.string" value="0_9"/>
+	<property name="version.string" value="0_10"/>
 	
 	<target name="release-all" depends="release-zip,release-src" />
 	
diff -ur ditaa-0.10/src/org/stathissideris/ascii2image/core/CommandLineConverter.java ditaa-0.10.patched/src/org/stathissideris/ascii2image/core/CommandLineConverter.java
--- ditaa-0.10/src/org/stathissideris/ascii2image/core/CommandLineConverter.java
+++ ditaa-0.10.patched/src/org/stathissideris/ascii2image/core/CommandLineConverter.java
@@ -46,7 +46,7 @@
  */
 public class CommandLineConverter {
 		
-	private static String notice = "ditaa version 0.9, Copyright (C) 2004--2009  Efstathios (Stathis) Sideris";
+	private static String notice = "ditaa version 0.10, Copyright (C) 2004--2009  Efstathios (Stathis) Sideris";
 	
 	private static String[] markupModeAllowedValues = {"use", "ignore", "render"};
 	
