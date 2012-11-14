require 'formula'

class Mp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/mp3splt/mp3splt/2.4.3/mp3splt-2.4.3.tar.gz'
  sha1 'b3acab4206d348fa8477f751e46840e41cb56046'

  depends_on 'libmp3splt'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
