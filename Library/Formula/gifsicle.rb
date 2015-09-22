class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "http://www.lcdf.org/gifsicle/"
  url "http://www.lcdf.org/gifsicle/gifsicle-1.88.tar.gz"
  sha256 "4585d2e683d7f68eb8fcb15504732d71d7ede48ab5963e61915201f9e68305be"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dda519ad02d5d287a17ceb84fc36e8746e1a15b35ff0a5c24f138ab280247b7" => :el_capitan
    sha256 "7946dca4fc1327add6a1693902ee9eeccb2a370a8ec87ec59f9a466aad8f7947" => :yosemite
    sha256 "59f5c2fa014c0a1e4c362f136bf01dcf7fb8c3bfaf6bb0839d0a370a18517985" => :mavericks
    sha256 "9f00374d5fe18ffb90ea2c96df43d440dd41cbb05aa820cb23398e9f4471d56b" => :mountain_lion
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
