class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.14.tar.gz"
  sha256 "9eb507e6358725d2cff69e3df169a572a1ab7b331131c78b02de6a79ce3e9b7a"

  bottle do
    cellar :any
    sha256 "d7eef5f22d8ec76b95d010dfed8a08cfad74fcf0674324d0b83306ff7d60317d" => :el_capitan
    sha256 "949957e3b098a6554dc60da2ff79242f8a54c19a9c4c14e307999b61a05fb1ba" => :yosemite
    sha256 "ae8ad0853256ee12f73ea78d5043e74c3866a7c5f5e93916b34f9414fe722220" => :mavericks
  end

  depends_on "openssl"
  depends_on "lzlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-lre"
  end
end
