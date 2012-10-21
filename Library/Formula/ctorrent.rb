require 'formula'

class Ctorrent < Formula
  url 'http://downloads.sourceforge.net/project/dtorrent/dtorrent/3.3.2/ctorrent-dnh3.3.2.tar.gz'
  homepage 'http://www.rahul.net/dholmes/ctorrent/'
  sha1 'd4e221f0292268f80e2430ce9d451dd64cf1ffaa'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
