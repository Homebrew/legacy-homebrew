require 'formula'

class Libspiro < Formula
  homepage 'http://libspiro.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/libspiro/libspiro/20071029/libspiro_src-20071029.tar.bz2'
  sha1 'd8b407b835b35289af2914877a4c6000b4fdd382'

  head 'https://libspiro.svn.sourceforge.net/svnroot/libspiro/'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
