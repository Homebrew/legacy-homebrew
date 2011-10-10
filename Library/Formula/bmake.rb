require 'formula'

class Bmake < Formula
  homepage 'http://www.crufty.net/help/sjg/bmake.html'
  url 'http://www.crufty.net/ftp/pub/sjg/bmake-20111001.tar.gz'
  md5 'b99e443b3fa96da8f71e8591e20db8f8'

  depends_on 'mk'

  def install
    system "./configure --with-default-sys-path='#{HOMEBREW_PREFIX}/share/mk'"
    system "sh ./make-bootstrap.sh"
    bin.install 'bmake'
    man.install 'bmake.1'

  end

end
