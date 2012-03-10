require 'formula'

class Mikmod < Formula
  url 'http://mikmod.raphnet.net/files/mikmod-3.2.2-beta1.tar.bz2'
  homepage 'http://mikmod.raphnet.net/'
  md5 '006378681d520fa8ee1dacca965bbd3c'

  depends_on 'libmikmod'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
