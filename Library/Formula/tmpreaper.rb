require 'formula'

class Tmpreaper < Formula
  homepage 'http://packages.debian.org/tmpreaper'
  url 'http://mirrors.kernel.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz'
  sha1 '96a490a9c2df6d3726af8df299e5aedd7d49fbfe'
  version '1.6.13_nmu1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
