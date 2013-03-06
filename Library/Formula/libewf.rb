require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'http://libewf.googlecode.com/files/libewf-20130128.tar.gz'
  sha1 '90fdd6878b8b3a001d486ca5608bc029ca21556d'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
