require 'formula'

class Mawk <Formula
  url 'http://invisible-island.net/datafiles/release/mawk.tar.gz'
  homepage 'http://invisible-island.net/mawk/mawk.html'
  md5 'b9cbddeb91d60f7183e9d46d8835ae9b'
  version '1.3.4'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-readline=/usr/lib"
    system "make install"
  end
end
