class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "http://www.lcdf.org/gifsicle/"
  url "http://www.lcdf.org/gifsicle/gifsicle-1.88.tar.gz"
  sha256 "4585d2e683d7f68eb8fcb15504732d71d7ede48ab5963e61915201f9e68305be"

  bottle do
    cellar :any
    sha1 "d618aaf92098835824b8dee876fa1953fc4b8ecb" => :yosemite
    sha1 "e4fd24422757c63836e9fa608ac00d9d5345b6c8" => :mavericks
    sha1 "c0fa1e99faced73ee843fd7e0936ebd0a3d2e37b" => :mountain_lion
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
