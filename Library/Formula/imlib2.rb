class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "http://sourceforge.net/projects/enlightenment/files/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.7/imlib2-1.4.7.tar.bz2"
  sha256 "35d733ce23ad7d338cff009095d37e656cb8a7a53717d53793a38320f9924701"

  bottle do
    sha256 "4b20ff58bc429b7a553e36b665d0d3d8b918eb9af8cd67fef34ca561a70ff543" => :yosemite
    sha256 "5675decb0b01e4ca1738ad722fcedc7d19c5c736b58e3b28b807ebe3f1e39c34" => :mavericks
    sha256 "edd83e83ed8c0a0b57a330aba23bf3b60ba7bd946e78386e8066276af3e5781a" => :mountain_lion
  end

  deprecated_option "without-x" => "without-x11"

  depends_on "freetype"
  depends_on "libpng" => :recommended
  depends_on :x11 => :recommended
  depends_on "pkg-config" => :build
  depends_on "jpeg" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
