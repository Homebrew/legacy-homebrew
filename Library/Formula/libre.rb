require "formula"

class Libre < Formula
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.8.tar.gz"
  sha1 "92bdf13a5e5ba445e1457d3fd6a20bb779c4b4b0"

  bottle do
    cellar :any
    sha1 "e1df554427260628e0caece4af46ada788d01b71" => :mavericks
    sha1 "4d2f74988be3fec1114f58cfb68ddf2eaac4d345" => :mountain_lion
    sha1 "87b68ce7e914643a1326cb55a18f75a02a711fc4" => :lion
  end

  depends_on "openssl"
  depends_on "lzlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-lre"
  end
end
