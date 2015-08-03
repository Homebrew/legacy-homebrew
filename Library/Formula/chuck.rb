class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.1.tgz"
  sha256 "d141ca61547131edd2b29bdb88183835e4133ef09807674bfa33a4e6e09d1f53"

  bottle do
    cellar :any
    sha256 "a7f640aafbc973549793d18e388ac0d95c7ce8380f4fc779796bf0d3bb13ffc1" => :yosemite
    sha256 "b0b9b98854278972e15ec803ba506756b3baf3049d8b625b5a698277c0be0782" => :mavericks
    sha256 "d5f7372ca9f939763a4ffd3894d8384797417cdb3455899f80da0f188c84f812" => :mountain_lion
  end

  # Fixes OS X version detection to include 10.11 through (thinking ahead) 10.13
  patch :DATA

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match /probe \[success\]/m, shell_output("#{bin}/chuck --probe 2>&1")
  end
end

__END__
diff --git a/src/makefile.osx b/src/makefile.osx
index a2c06ba..ac95278 100644
--- a/src/makefile.osx
+++ b/src/makefile.osx
@@ -1,7 +1,7 @@
 # uncomment the following to force 32-bit compilation
 # FORCE_M32=-m32

-ifneq ($(shell sw_vers -productVersion | egrep '10\.(6|7|8|9|10)(\.[0-9]+)?'),)
+ifneq ($(shell sw_vers -productVersion | egrep '10\.(6|7|8|9|10|11|12|13)(\.[0-9]+)?'),)
 SDK=$(shell xcodebuild -sdk macosx -version | grep '^Path:' | sed 's/Path: \(.*\)/\1/')
 ISYSROOT=-isysroot $(SDK)
 LINK_EXTRAS=-F/System/Library/PrivateFrameworks \
