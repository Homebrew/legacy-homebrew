require 'formula'

class Tmpreaper < Formula
  url 'http://mirrors.kernel.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz'
  homepage 'http://packages.debian.org/tmpreaper'
  md5 '36bffb38fbdd28b9de8af229faabf5fe'
  version '1.6.13_nmu1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
