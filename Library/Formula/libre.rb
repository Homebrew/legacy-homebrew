class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.14.tar.gz"
  sha256 "9eb507e6358725d2cff69e3df169a572a1ab7b331131c78b02de6a79ce3e9b7a"

  bottle do
    cellar :any
    sha256 "0b2c92c17d6962e807ca5afcd495e6dae901ff797510dda1bc653bb9f10ca6b1" => :el_capitan
    sha256 "cf02e7c51634efbda62471097647b0c26a07fa00ca432bf4eaa57d4a4fe56711" => :yosemite
    sha256 "46562eff71fcd8521112baa61231c45e7543af440f546479bc88bc8a0e63d304" => :mavericks
    sha256 "de6f93149926c6eeda4b10c19a555dfc186fff9cdbd9bc356084589e18553e23" => :mountain_lion
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
