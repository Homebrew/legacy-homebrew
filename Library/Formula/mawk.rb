require 'formula'

class Mawk <Formula
  url 'http://invisible-island.net/datafiles/release/mawk.tar.gz'
  homepage 'http://invisible-island.net/mawk/mawk.html'
  md5 '447e7c322fa1e58141f5085bae87351f'
  version '1.3.4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make install"
  end
end
