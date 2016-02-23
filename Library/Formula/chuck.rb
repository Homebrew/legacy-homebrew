class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.1.tgz"
  sha256 "d141ca61547131edd2b29bdb88183835e4133ef09807674bfa33a4e6e09d1f53"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "7b51eee3ac7ac860b2cc4f99c00508250bdbf14c4a72e6e7cc2cade99690c26f" => :el_capitan
    sha256 "e90d7190c6f06ba2107d4f3bf85ca798840642f00c6bb1f3872cc0a05efa3b83" => :yosemite
    sha256 "ae23a194badab407ea3489991314f295f2ec7c6942dd60f0e81925eb94333dec" => :mavericks
    sha256 "87d6cc4e3a3b868ee1a98f2e148060ed4a69d2cd593944ebed83fe887c7cd080" => :mountain_lion
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
