require 'formula'

class Medusa < Formula
  url 'http://www.foofus.net/jmk/tools/medusa-2.0.tar.gz'
  homepage 'http://www.foofus.net/~jmk/medusa/medusa.html'
  md5 '75df63e1cd3b0d18fd2b017f12fc51d7'

  depends_on 'libssh2'

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    doc.install Dir['doc/*']
    doc.install ['AUTHORS', 'COPYING', 'ChangeLog', 'README']
  end
end
