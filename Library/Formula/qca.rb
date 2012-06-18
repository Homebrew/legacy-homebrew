require 'formula'

class Qca < Formula
  homepage 'http://delta.affinix.com/qca/'
  url 'http://delta.affinix.com/download/qca/2.0/qca-2.0.3.tar.bz2'
  sha1 '9c868b05b81dce172c41b813de4de68554154c60'

  depends_on 'qt'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-tests"
    system "make install"
  end
end
