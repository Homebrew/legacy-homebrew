require 'formula'

class Mp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://sourceforge.net/projects/mp3splt/files/mp3splt/2.5.1/mp3splt-2.5.1.tar.gz'
  sha1 '75551f12f349312d2e8fcc58bbadab134e9e3a99'

  depends_on 'libmp3splt'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
