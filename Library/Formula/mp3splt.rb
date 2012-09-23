require 'formula'

class Mp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/mp3splt/mp3splt/2.4.2/mp3splt-2.4.2.tar.gz'
  sha1 '0a66b2e2cfc6091cfd0dc9fc303a0650de3bc738'

  depends_on 'libmp3splt'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
