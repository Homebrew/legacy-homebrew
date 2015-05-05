class Giflossy < Formula
  desc "Lossy LZW compression, reduces GIF file sizes by 30-50%"
  homepage "https://pornel.net/lossygif"
  url "https://github.com/pornel/giflossy/archive/lossy/1.82.1.tar.gz"
  sha256 "a0d048f0c2274c81532a988d2f3ea16c3f1cbb6878f13deeb425d34826e4ed23"
  head "https://github.com/pornel/giflossy.git"

  conflicts_with "gifsicle",
    :because => "both install an `gifsicle` binary"

  option "with-x11", "Install gifview"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gifsicle", "-O3", "--lossy=80", "-o" "out.gif", test_fixtures("test.gif")
  end
end
