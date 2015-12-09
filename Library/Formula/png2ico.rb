class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "http://www.winterdrache.de/freeware/png2ico/"
  url "http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  bottle do
    cellar :any
    sha256 "092829cdf12cc8bf24460451078eb5b34d12f5b8b60f134e270bfee3a05683f4" => :yosemite
    sha256 "0257cd8aa4f18fa941400b7d0db2f333d9d6e053d38e264bd83642d400e48173" => :mavericks
    sha256 "9f87f833f8474ef15a81f32f25c7794b68fa956093dd532c5874b0da9ebaf970" => :mountain_lion
  end

  revision 1

  depends_on "libpng"

  # Fix build with recent clang
  patch :DATA

  def install
    inreplace "Makefile", "g++", "$(CXX)"
    system "make", "CPPFLAGS=#{ENV.cxxflags} #{ENV.cppflags} #{ENV.ldflags}"
    bin.install "png2ico"
    man1.install "doc/png2ico.1"
  end

  test do
    system "#{bin}/png2ico", "out.ico", test_fixtures("test.png")
    assert File.exist?("out.ico")
  end
end

__END__
diff --git a/png2ico.cpp b/png2ico.cpp
index 8fb87e4..9dedb97 100644
--- a/png2ico.cpp
+++ b/png2ico.cpp
@@ -34,6 +34,7 @@ Notes about transparent and inverted pixels:
 #include <cstdio>
 #include <vector>
 #include <climits>
+#include <cstdlib>
 
 #if __GNUC__ > 2
 #include <ext/hash_map>
