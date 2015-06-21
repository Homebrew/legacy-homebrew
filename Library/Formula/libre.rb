require "formula"

class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.12.tar.gz"
  sha256 "0d44028ce9c156b2ca34ec7ead8f44a59d3dca57b048edb3410d94cc8b634df2"

  bottle do
    cellar :any
    sha1 "988a4f3820de85831e75742c24e85eb6188db5d5" => :yosemite
    sha1 "fe96e2b8ba7c8a2964b445613172489cd46c4ed8" => :mavericks
    sha1 "b0c37d9a349da7f2ac28ab3b2153c2fc5a0427c4" => :mountain_lion
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
