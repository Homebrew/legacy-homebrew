require 'formula'

class Axel < Formula
  homepage 'http://axel.alioth.debian.org'
  url 'http://pkgs.fedoraproject.org/repo/pkgs/axel/axel-2.4.tar.gz/a2a762fce0c96781965c8f9786a3d09d/axel-2.4.tar.gz'
  sha1 '6d89a7ce797ddf4c23a210036d640d013fe843ca'

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make install"
  end
end
