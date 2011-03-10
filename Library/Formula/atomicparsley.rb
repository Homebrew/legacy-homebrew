require 'formula'

class Atomicparsley < Formula
  url 'http://bitbucket.org/wez/atomicparsley/get/0.9.3.tar.bz2'
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  md5 'af94c6e1d5d63978fbc94ee9f51a4715'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end

