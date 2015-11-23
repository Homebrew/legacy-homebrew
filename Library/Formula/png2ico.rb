class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "http://www.winterdrache.de/freeware/png2ico/"
  url "http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  bottle do
    cellar :any
    sha1 "b3c0353afa9ea55e8dc9e8f41eeaac8968f569d3" => :yosemite
    sha1 "75edd65a4d22ec52b41010b2c8140e3fe20c0895" => :mavericks
    sha1 "1d603b519c4067f20de399892d85fbcd834a9f39" => :mountain_lion
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
