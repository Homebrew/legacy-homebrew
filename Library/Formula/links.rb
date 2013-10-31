require 'formula'

class Links < Formula
  homepage 'http://links.twibright.com/'
  url 'http://links.twibright.com/download/links-2.8.tar.gz'
  sha1 'a92cf0c203fc765ef46974f15b2f738f2aec6b00'

  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--enable-graphics" if build.with? 'x11'

    system "./configure", *args
    system "make install"
  end
end
