require 'formula'

class Raptor < Formula
  homepage 'http://librdf.org/raptor/'
  url 'http://download.librdf.org/source/raptor2-2.0.11.tar.gz'
  sha1 '5e1596e45b1e186972b464a977fbc57941c9afc8'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
