class Teapot < Formula
  homepage "http://www.syntax-k.de/projekte/teapot/"
  url "http://www.syntax-k.de/projekte/teapot/teapot-2.3.0.tar.gz"
  sha256 "580e0cb416ae3fb3df87bc6e92e43bf72929d47b65ea2b50bc09acea3bff0b65"

  depends_on "cmake" => :build

  # The upstream tarball still defines the version number as "2.2.1", even
  # though the tarball contains the directory name "teapot-2.3.0" and there are
  # significant differences between this and the 2.2.1 tarball.
  patch :DATA

  def install
    args = std_cmake_args + ["-DENABLE_HELP=OFF", ".."]
    mkdir "macbuild" do
      system "cmake", *args
      system "make", "install"
    end
    doc.install "doc/teapot.lyx"
  end
end
__END__
diff --git a/config.h b/config.h
index 2a4e34f..cdf11a1 100644
--- a/config.h
+++ b/config.h
@@ -1,7 +1,7 @@
 /* configuration values */


-#define VERSION "2.2.1"
+#define VERSION "2.3.0"

 #define HELPFILE "/usr/local/share/doc/teapot/html/index.html"
