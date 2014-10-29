require "formula"

class Gifsicle < Formula
  homepage "http://www.lcdf.org/gifsicle/"
  url "http://www.lcdf.org/gifsicle/gifsicle-1.86.tar.gz"
  sha1 "517e68b781594851750d7d807e25bd18b1f5dbc4"

  option "with-x11", "Install gifview"

  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
