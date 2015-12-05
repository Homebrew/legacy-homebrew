class Libmodplug < Formula
  desc "Library from the Modplug-XMMS project"
  homepage "http://modplug-xmms.sourceforge.net/"
  url "https://downloads.sourceforge.net/modplug-xmms/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz"
  sha256 "77462d12ee99476c8645cb5511363e3906b88b33a6b54362b4dbc0f39aa2daad"

  bottle do
    cellar :any
    revision 1
    sha256 "78d2179c1b2994f70d4182c3abfb611e28480fc6ca2dea2640371b40788e216a" => :yosemite
    sha256 "b6164ec2cddc9666b5a1c4e0a8660bcd51eebfa771d46b004b3090e656792626" => :mavericks
    sha256 "328cd2470af295b2d48ddd948e006a6df5ff13b23f9c05dceb9be75954142359" => :mountain_lion
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
    sha256 "f80735b77123cc7e02c4dad6ce8197bfefcb8748b164a66ffecd206cc4b63d97"
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
