require 'formula'

class Jbig2dec < Formula
  homepage 'http://jbig2dec.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/jbig2dec/jbig2dec/0.11/jbig2dec-0.11.tar.gz'
  sha1 '349cd765616db7aac1f4dd1d45957d1da65ea925'

  bottle do
    cellar :any
    sha1 "e00cb60ee3f381b625c0c9c6225102c1261fb1a0" => :mavericks
    sha1 "a9a442415f9dc5f61d6e487abe5dd1344f1483aa" => :mountain_lion
    sha1 "cbb4dfe055be243427210d03304c20760fb00bd7" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/jbig2dec", "--version"
  end
end
