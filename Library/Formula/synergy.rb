class Synergy < Formula
  homepage "http://synergy-project.org"
  url "https://github.com/synergy/synergy/archive/1.6.3.tar.gz"
  sha256 "93b1965b8e0cfc55cc654aab7053a58b9e730d09e68bbc520be32353a01dce1a"

  depends_on "cmake" => :build
  depends_on "qt5" => :build

  patch :DATA

  def install
    system "./hm.sh", "conf", "-g1", "--mac-sdk", "#{MacOS.version}", "--mac-identity", "test"
    system "./hm.sh", "build"

    bin.install "bin/synergyc"
    bin.install "bin/synergyd"
    bin.install "bin/synergys"
    bin.install "bin/syntool"

    prefix.install "bin/Synergy.app"
  end
end

# First patch is a fix for building for OSX. There is an error where the default
# generate "Unix Makefile" target is set, it's not getting within OSX setup.
# cf https://github.com/synergy/synergy/issues/3797#issuecomment-87760764

# Second patch is to drop code signing within the build engine.

__END__
diff --git a/ext/toolchain/commands1.py b/ext/toolchain/commands1.py
index 9f4cb4a..0c7b0e3 100644
--- a/ext/toolchain/commands1.py
+++ b/ext/toolchain/commands1.py
@@ -450,7 +450,7 @@ class InternalCommands:
 		if generator.cmakeName.find('Unix Makefiles') != -1:
 			cmake_args += ' -DCMAKE_BUILD_TYPE=' + target.capitalize()
 			
-		elif sys.platform == "darwin":
+		if sys.platform == "darwin":
			macSdkMatch = re.match("(\d+)\.(\d+)", self.macSdk)
			if not macSdkMatch:
				raise Exception("unknown osx version: " + self.macSdk)
@@ -776,15 +776,10 @@ class InternalCommands:
 			raise Exception("Python 2.4 or greater required.")
 
 		(qMajor, qMinor, qRev) = self.getQmakeVersion()
-		if qMajor >= 5:
-			output = commands.getstatusoutput(
-				"macdeployqt %s/Synergy.app -verbose=2 -codesign='%s'" % (
-				targetDir, self.macIdentity))
-		else:
-			# no code signing available in old versions
-			output = commands.getstatusoutput(
-				"macdeployqt %s/Synergy.app -verbose=2" % (
-				targetDir))
+		# no code signing available in old versions
+		output = commands.getstatusoutput(
+			"macdeployqt %s/Synergy.app -verbose=2" % (
+			targetDir))
 
 		print output[1]
 		if "ERROR" in output[1]:
