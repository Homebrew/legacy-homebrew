require 'formula'

class Openssh <Formula
  url 'http://ftp5.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-5.7p1.tar.gz'
  homepage 'http://openssh.com/portable.html'
  md5 '50231fa257219791fa41b84a16c9df04'
  version '5.7p1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
