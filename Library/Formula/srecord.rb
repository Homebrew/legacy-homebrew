require 'formula'

class Srecord < Formula
  homepage 'http://srecord.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/srecord/srecord/1.59/srecord-1.59.tar.gz'
  md5 '5e01ba19c4f3fb8b5beca47cb46665f2'

  depends_on 'boost'
  depends_on 'libgcrypt'

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make install"
  end
end
