class Teapot < Formula
  desc "Table editor and planner"
  homepage "http://www.syntax-k.de/projekte/teapot/"
  url "http://www.syntax-k.de/projekte/teapot/teapot-2.3.0.tar.gz"
  sha256 "580e0cb416ae3fb3df87bc6e92e43bf72929d47b65ea2b50bc09acea3bff0b65"

  bottle do
    cellar :any
    sha256 "02cfa676915adfa9702eab91be72c757bb250d492f446a7f3f084dcff2d63727" => :yosemite
    sha256 "13998ff994a63d0e59fb99582c18aee845d760706591ae8e0f57036aa9f685d5" => :mavericks
    sha256 "c130b452b7d339181fff49b4f5438de67c56402f81b9fffe10a154fa07351dcb" => :mountain_lion
  end

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
