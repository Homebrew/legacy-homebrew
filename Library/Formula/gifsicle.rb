class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.88.tar.gz"
  sha256 "4585d2e683d7f68eb8fcb15504732d71d7ede48ab5963e61915201f9e68305be"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2d40a7dc8d0f2a39134872a99ab8e8c3f5e5dc6381826abdd8d4f89c3fe287d0" => :el_capitan
    sha256 "f4699986ab815c25764b4c7049fc067d6209922bcfd8b841bb19f2ae41c66f8d" => :yosemite
    sha256 "29af107b09e41c0e40a10411565345cb636e724cd28e9d2f4e58c5dc0dd819c9" => :mavericks
  end

  head do
    url "https://github.com/kohler/gifsicle.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  conflicts_with "giflossy",
    :because => "both install an `gifsicle` binary"

  option "with-x11", "Install gifview"

  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
