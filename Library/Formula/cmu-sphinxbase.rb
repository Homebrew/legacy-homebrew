require 'formula'

class CmuSphinxbase < Formula
  url 'http://sourceforge.net/projects/cmusphinx/files/sphinxbase/0.7/sphinxbase-0.7.tar.gz'
  homepage 'http://cmusphinx.sourceforge.net/'
  md5 '7c28f37c0eb9e30e22e9992eace3b605'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
