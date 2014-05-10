require "formula"

class Libre < Formula
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.8.tar.gz"
  sha1 "92bdf13a5e5ba445e1457d3fd6a20bb779c4b4b0"

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
