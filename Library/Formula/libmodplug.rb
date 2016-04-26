class Libmodplug < Formula
  desc "Library from the Modplug-XMMS project"
  homepage "http://modplug-xmms.sourceforge.net/"
  url "https://downloads.sourceforge.net/modplug-xmms/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz"
  sha256 "77462d12ee99476c8645cb5511363e3906b88b33a6b54362b4dbc0f39aa2daad"

  bottle do
    cellar :any
    revision 2
    sha256 "32f92108df7cbcb04fd08ee34cace282a39b073e37e3116df181c1674f3089a3" => :el_capitan
    sha256 "ca58e85ca80a2d2199a37203fd1df19d112a4c63e357b96d0348043fbc3a93f8" => :yosemite
    sha256 "c384456109eaced707376c862ddb087f355838958e32ec35ceb544cc6169d098" => :mavericks
  end

  resource "testmod" do
    # Most favourited song on modarchive:
    # http://modarchive.org/index.php?request=view_by_moduleid&query=60395
    url "http://api.modarchive.org/downloads.php?moduleid=60395#2ND_PM.S3M"
    sha256 "f80735b77123cc7e02c4dad6ce8197bfefcb8748b164a66ffecd206cc4b63d97"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # First a basic test just that we can link on the library
    # and call an initialization method.
    (testpath/"test_null.cpp").write <<-EOS.undent
      #include "libmodplug/modplug.h"
      int main() {
        ModPlugFile* f = ModPlug_Load((void*)0, 0);
        if (!f) {
          // Expecting a null pointer, as no data supplied.
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test_null.cpp", "-lmodplug", "-o", "test_null"
    system "./test_null"

    # Second, acquire an actual music file from a popular internet
    # source and attempt to parse it.
    resource("testmod").stage testpath
    (testpath/"test_mod.cpp").write <<-EOS.undent
      #include "libmodplug/modplug.h"
      #include <fstream>
      #include <sstream>

      int main() {
        std::ifstream in("downloads.php");
        std::stringstream buffer;
        buffer << in.rdbuf();
        int length = buffer.tellp();
        ModPlugFile* f = ModPlug_Load(buffer.str().c_str(), length);
        if (f) {
          // Expecting success
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test_mod.cpp", "-lmodplug", "-lstdc++", "-o", "test_mod"
    system "./test_mod"
  end
end
