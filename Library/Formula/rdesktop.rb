require 'formula'

class Rdesktop < Formula
  homepage 'http://www.rdesktop.org/'
  url 'http://downloads.sourceforge.net/project/rdesktop/rdesktop/1.7.1/rdesktop-1.7.1.tar.gz'
  sha1 'c718d0f49948a964c7ef8424b8ade73ecce3aba3'

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
