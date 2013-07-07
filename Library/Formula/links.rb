require 'formula'

class Links < Formula
  homepage 'http://links.twibright.com/'
  url 'http://links.twibright.com/download/links-2.7.tar.gz'
  sha1 'e0773f2b23397bcbd08d5a3145d94e446dfb4969'

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
