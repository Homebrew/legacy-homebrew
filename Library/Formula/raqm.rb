class Raqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/releases/download/v0.1.0/raqm-0.1.0.tar.gz"
  sha256 "fbccf176ae0ff5aeb73ea3d7a0f2173c432d87a495c10ca2ecdf82323eaa5355"

  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "fribidi"
  depends_on "glib" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <raqm.h>
      int main() {
        assert(raqm_create());
        return 0;
      }
    EOS
    (testpath/"Makefile").write <<-EOS.undent
      CFLAGS = $(shell pkg-config --cflags raqm)
      LDLIBS = $(shell pkg-config --libs raqm)
      all: test
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    system "make"
    system "./test"
  end
end
