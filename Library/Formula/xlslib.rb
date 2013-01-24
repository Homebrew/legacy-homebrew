require 'formula'

class Xlslib < Formula
  homepage 'http://sourceforge.net/projects/xlslib'
  url 'http://sourceforge.net/projects/xlslib/files/xlslib-2.3.4.zip'
  sha1 '5f06a4195239753083594fb83cf0178d12545f15'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
