require 'formula'

class Talloc < Formula
  url 'http://www.samba.org/ftp/talloc/talloc-2.0.7.tar.gz'
  homepage 'http://talloc.samba.org/'
  md5 'dbfb3146f4cc47054e13b8a2988299f9'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-rpath"
    system "make install"
  end
end
