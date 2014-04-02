require "formula"

class Gifsicle < Formula
  homepage "http://www.lcdf.org/gifsicle/"
  url "http://www.lcdf.org/gifsicle/gifsicle-1.82.tar.gz"
  sha1 "2771af4ab39064df04a538bcb6f777d2ba3d628b"

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
end
