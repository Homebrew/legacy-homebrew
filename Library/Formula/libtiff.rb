require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'ftp://ftp.remotesensing.org/pub/libtiff/tiff-3.9.5.zip'
  sha256 '332d1a658340c41791fce62fb8fff2a5ba04c2e82b8b85e741eb0a7b30e0d127'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
