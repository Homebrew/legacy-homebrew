require "formula"

class Qrencode < Formula
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://fukuchi.org/works/qrencode/qrencode-3.4.4.tar.gz"
  sha1 "644054a76c8b593acb66a8c8b7dcf1b987c3d0b2"

  head do
    url "https://github.com/fukuchi/libqrencode.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qrencode", "123456789", "-o", "test.png"
  end
end
