require 'formula'

class Csvprintf < Formula
  url 'http://csvprintf.googlecode.com/files/csvprintf-1.0.tar.gz'
  homepage 'http://code.google.com/p/csvprintf/'
  md5 '6ad0315064c47a21b06da440d211e5c0'

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    system "./configure", *args
    system "make install"
  end
end
