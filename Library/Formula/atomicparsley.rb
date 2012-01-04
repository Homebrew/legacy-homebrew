require 'formula'

class Atomicparsley < Formula
  url 'https://bitbucket.org/wez/atomicparsley/get/0.9.4.tar.bz2'
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  md5 '2ce6f39cedc959f46b5515920c35d0d7'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end

