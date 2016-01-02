class Teapot < Formula
  desc "Table editor and planner"
  homepage "https://www.syntax-k.de/projekte/teapot/"
  url "https://www.syntax-k.de/projekte/teapot/teapot-2.3.0.tar.gz"
  sha256 "580e0cb416ae3fb3df87bc6e92e43bf72929d47b65ea2b50bc09acea3bff0b65"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "84673e8886e1f24250116d8c423383d0babbc53e1cb669ba46b45a37a2344399" => :el_capitan
    sha256 "0ffd7fa1ac31cc91c9c71d225d26970e23da5719d7505d4a1dcaf40617c44afb" => :yosemite
    sha256 "24dd3dfcdc52f47f3247ae56931cc9864434118e8d097e64e72201fdaeb08391" => :mavericks
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
