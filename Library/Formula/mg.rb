require 'formula'

class Mg < Formula
  url 'http://homepage.boetes.org/software/mg/mg-20110905.tar.gz'
  homepage 'http://homepage.boetes.org/software/mg/'
  md5 '2de35316fa8ebafe6003efaae70b723e'

  def install
    # -Wno-error=unused-but-set-variable requires GCC 4.6+
    inreplace 'Makefile.in', '-Wno-error=unused-but-set-variable', ''
    system "./configure"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
    doc.install "tutorial"
  end
end
