require 'formula'

class Mawk <Formula
  url 'http://invisible-island.net/datafiles/release/mawk.tar.gz'
  homepage 'http://invisible-island.net/mawk/mawk.html'
  md5 '11b223c1f92d390f2839e71b51f7234d'
  version '1.3.4'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-readline=/usr/lib"
    system "make install"
  end
end
