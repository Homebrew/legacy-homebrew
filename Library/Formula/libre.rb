require "formula"

class Libre < Formula
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.8.tar.gz"
  sha1 "92bdf13a5e5ba445e1457d3fd6a20bb779c4b4b0"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha1 "390bde82308366ebed75d2b1d0be82a0d7d96078" => :yosemite
    sha1 "77ab73229421ff69668e4c98ca50df4ba5bbee5b" => :mavericks
    sha1 "3d3eeaf47ebeeca2dc37fa7ac8e3e865f4050455" => :mountain_lion
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
