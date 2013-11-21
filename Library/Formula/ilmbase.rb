require 'formula'

class Ilmbase < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/ilmbase-2.0.1.tar.gz'
  sha1 'bfa62519094413f686c6f08c5923b47a10eea180'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

