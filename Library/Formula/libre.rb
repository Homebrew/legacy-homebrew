require "formula"

class Libre < Formula
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.8.tar.gz"
  sha1 "92bdf13a5e5ba445e1457d3fd6a20bb779c4b4b0"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "88d1c5f7d23fd08a42a3ec48ad95fc7f7fc2a679" => :mavericks
    sha1 "a480cb5227b0d7c8e25152e93696f8be412c3f40" => :mountain_lion
    sha1 "f369dceb197128b47afa6a4010ebfe8b934cde12" => :lion
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
