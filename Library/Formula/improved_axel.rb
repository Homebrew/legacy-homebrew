require 'formula'

class ImprovedAxel < Formula
  homepage 'https://github.com/emiraga/axel'
  url 'https://github.com/emiraga/axel/archive/master.zip'
  sha1 'd5d9537b03f62892552a1da95c3cf4a8012077aa'
  version '2.4'

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make install"
  end
end
