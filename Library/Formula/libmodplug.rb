require "formula"

class Libmodplug < Formula
  homepage "http://modplug-xmms.sourceforge.net/"
  url "https://downloads.sourceforge.net/modplug-xmms/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz"
  sha1 "771ee75bb8bfcfe95eae434ed1f3b2c5b63b2cb3"

  bottle do
    cellar :any
    sha1 "3a2b647f1cc24e83c626898087a20a3ec0978963" => :mavericks
    sha1 "0e409711ad515e7f739dcec3792d0bd3ab9652bc" => :mountain_lion
    sha1 "280ba8ba18963cd71616f7e6a5a1cc6d9e510203" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  resource "testmod" do
    # Most favourited song on modarchive:
    # http://modarchive.org/index.php?request=view_by_moduleid&query=60395
    url "http://api.modarchive.org/downloads.php?moduleid=60395#2ND_PM.S3M"
    sha1 "db0d80984abca47d5442bc4de467f9ccd300f186"
  end

  test do
    # First a basic test just that we can link on the library
    # and call an initialization method.
    (testpath/'test_null.cpp').write <<-EOS.undent
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
    (testpath/'test_mod.cpp').write <<-EOS.undent
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
