require 'formula'

class Mp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/mp3splt/mp3splt/2.4.2/mp3splt-2.4.2.tar.gz'
  md5 'f4c5c42f9dec9fb72b7f6ffeacd82906'

  depends_on 'libmp3splt'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
