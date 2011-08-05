require 'formula'

class Cfengine < Formula
  url 'http://cfengine.com/tarballs/download.php?file=cfengine-3.2.0b3.tar.gz'
  homepage 'http://cfengine.com/'
  md5 '2efea150847841bd86aaf93152be317c'

  depends_on 'tokyo-cabinet'

  def install
    system "./configure", "--with-tokyocabinet", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "/usr/bin/make install"
  end
end
