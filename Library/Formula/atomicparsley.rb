require 'formula'

class Atomicparsley <Formula
  url 'http://bitbucket.org/wez/atomicparsley/get/0.9.3.tar.bz2'
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  md5 '5ab12e2e8b201f3341a37628973722e0'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end

