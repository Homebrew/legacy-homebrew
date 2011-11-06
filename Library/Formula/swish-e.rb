require 'formula'

class SwishE < Formula
  url 'http://swish-e.org/distribution/swish-e-2.4.7.tar.gz'
  homepage 'http://swish-e.org/'
  md5 '736db7a65aed48bb3e2587c52833642d'

  depends_on 'libxml2'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
