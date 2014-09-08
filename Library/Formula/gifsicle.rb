require "formula"

class Gifsicle < Formula
  homepage "http://www.lcdf.org/gifsicle/"
  url "http://www.lcdf.org/gifsicle/gifsicle-1.84.tar.gz"
  sha1 "131a3e53a1d49318b54f9c6f81a62726384e95d7"

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
