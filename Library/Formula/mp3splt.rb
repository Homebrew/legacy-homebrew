require 'formula'

class Mp3splt < Formula
  url 'http://downloads.sourceforge.net/project/mp3splt/mp3splt/2.3a/mp3splt-2.3a.tar.gz'
  homepage 'http://mp3splt.sourceforge.net'
  md5 '1fe663f7de5a6949bbe5b6aa78fea79f'

  depends_on 'libmp3splt'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
