require 'formula'

class CmuSphinxbase < Formula
  url 'http://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.6.1/sphinxbase-0.6.1.tar.gz'
  homepage 'http://cmusphinx.sourceforge.net/'
  md5 '779647b5fb9e9942994f02fdf2282351'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
