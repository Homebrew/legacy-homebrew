require 'formula'

class Mp3splt < Formula
  url 'http://downloads.sourceforge.net/project/mp3splt/mp3splt/mp3splt-2.4.1.tar.gz'
  homepage 'http://mp3splt.sourceforge.net'
  md5 'aed4a94f996abcdb07679206a600fc5b'

  depends_on 'libmp3splt'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
