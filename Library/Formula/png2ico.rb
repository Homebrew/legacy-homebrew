class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "http://www.winterdrache.de/freeware/png2ico/"
  url "http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "19b80cbf09671aa0dd1a355e025617d8c796baed200c93585037a34715a02762" => :el_capitan
    sha256 "a0bc61603d8861f82578a3686d55870e651bac6c0c0f029426e56e62428253e1" => :yosemite
    sha256 "8c514f8a5aacc0720332e091a2480bd609a7a42df235c6daec948f0dda92faad" => :mavericks
  end

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
