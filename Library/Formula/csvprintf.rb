require 'formula'

class Csvprintf < Formula
  homepage 'http://code.google.com/p/csvprintf/'
  url 'http://csvprintf.googlecode.com/files/csvprintf-1.0.tar.gz'
  md5 '6ad0315064c47a21b06da440d211e5c0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
