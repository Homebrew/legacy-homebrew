require 'formula'

class Ctorrent < Formula
  url 'http://downloads.sourceforge.net/project/dtorrent/dtorrent/3.3.2/ctorrent-dnh3.3.2.tar.gz'
  homepage 'http://www.rahul.net/dholmes/ctorrent/'
  md5 '59b23dd05ff70791cd6449effa7fc3b6'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
