require 'formula'

class Axel < Formula
  homepage 'http://packages.debian.org/wheezy/axel'
  url 'http://ftp.de.debian.org/debian/pool/main/a/axel/axel_2.4.orig.tar.gz'
  sha1 '6d89a7ce797ddf4c23a210036d640d013fe843ca'

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make install"
  end
end
