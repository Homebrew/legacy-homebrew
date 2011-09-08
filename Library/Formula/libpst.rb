require 'formula'

class Libpst < Formula
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.53.tar.gz'
  homepage 'http://www.five-ten-sg.com/libpst/'
  md5 'e030d3128562ac189c2400dedec36b86'

  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-boost-python=boost_python-mt"
    system "make install"
  end
end
