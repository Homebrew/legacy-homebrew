require 'formula'

class Mg < Formula
  homepage 'http://homepage.boetes.org/software/mg/'
  url 'http://homepage.boetes.org/software/mg/mg-20110905.tar.gz'
  sha1 '51d2bac801cab33c9b552c36db5f8637fbbe9363'

  def install
    # -Wno-error=unused-but-set-variable requires GCC 4.6+
    inreplace 'Makefile.in', '-Wno-error=unused-but-set-variable', ''
    system "./configure"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
    doc.install "tutorial"
  end
end
