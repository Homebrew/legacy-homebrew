class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://fukuchi.org/works/qrencode/qrencode-3.4.4.tar.gz"
  sha256 "e794e26a96019013c0e3665cb06b18992668f352c5553d0a553f5d144f7f2a72"

  bottle do
    cellar :any
    sha256 "199fe87d536ffab8075f49d0fc95ddb1a3c45db8cdc26cfc6c2aa3a4b1379c0a" => :el_capitan
    sha256 "2866e5c3b66b55d8bfb98c674e8467f4ca60de3994d82216277d9a8c88633672" => :yosemite
    sha256 "1365ca76177b060b8f83d69f28711cd92d21fc9c9596ce32f4b4fae5a195854a" => :mavericks
    sha256 "559fb8304c7da49cc214de238c57c6322ae8b389f102acb20f8b537e7f587814" => :mountain_lion
  end

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
