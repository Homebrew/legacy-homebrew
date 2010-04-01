require 'formula'

class Atomicparsley <Formula
  url 'http://bitbucket.org/wez/atomicparsley/get/0.9.3.tar.bz2'
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  md5 'a405fc4b7029ad1ea104dba82dff4b63'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end

