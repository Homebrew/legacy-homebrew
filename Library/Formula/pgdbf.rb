require 'formula'

class Pgdbf < Formula
  homepage 'https://github.com/kstrauser/pgdbf'
  url 'http://downloads.sourceforge.net/project/pgdbf/pgdbf/0.6.2/pgdbf-0.6.2.tar.xz'
  sha1 '36ddf162b594ac328456a21d057b787c93ec1abb'

  depends_on 'xz' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
