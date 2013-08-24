require 'formula'

class Rdesktop < Formula
  homepage 'http://www.rdesktop.org/'
  url 'http://downloads.sourceforge.net/project/rdesktop/rdesktop/1.8.0/rdesktop-1.8.0.tar.gz'
  sha1 '2d39a41d29ad1ad2509d1e343a2817a3c7d666de'

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
