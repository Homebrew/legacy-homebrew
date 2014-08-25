require "formula"

class Libre < Formula
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.8.tar.gz"
  sha1 "92bdf13a5e5ba445e1457d3fd6a20bb779c4b4b0"
  revision 1

  bottle do
    cellar :any
    sha1 "9d4720852f6ae6c65def0a8d4b1746b026fd966f" => :mavericks
    sha1 "b5118af4f1a2094131355f4d7a030a58f7e2ca5d" => :mountain_lion
    sha1 "d79a0aaf97c024c65ef17130e9e0d52007f506b9" => :lion
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
