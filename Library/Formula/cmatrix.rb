require 'formula'

class Cmatrix < Formula
  url 'http://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz'
  homepage 'http://www.asty.org/cmatrix/'
  md5 'ebfb5733104a258173a9ccf2669968a1'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
