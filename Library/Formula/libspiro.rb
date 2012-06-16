require 'formula'

class Libspiro < Formula
  homepage 'http://libspiro.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/libspiro/libspiro/20071029/libspiro_src-20071029.tar.bz2'
  md5 'ab6aaa50bbd8fa55e78f8b8b0112f6cd'
  head 'https://libspiro.svn.sourceforge.net/svnroot/libspiro/'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

end
