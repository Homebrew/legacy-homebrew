require 'formula'

class Ctorrent < Formula
  homepage 'http://www.rahul.net/dholmes/ctorrent/'
  url 'https://downloads.sourceforge.net/project/dtorrent/dtorrent/3.3.2/ctorrent-dnh3.3.2.tar.gz'
  sha1 'd4e221f0292268f80e2430ce9d451dd64cf1ffaa'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
