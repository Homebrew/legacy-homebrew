require 'formula'

class Atomicparsley <Formula
  url 'http://bitbucket.org/wez/atomicparsley/get/0.9.3.tar.bz2'
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  md5 'c1a859f0cdcfb2b02d53a2784b6cc662'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end

