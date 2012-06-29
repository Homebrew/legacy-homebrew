require 'formula'

class Libpst < Formula
  homepage 'http://www.five-ten-sg.com/libpst/'
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.54.tar.gz'
  sha1 'a4713b87e330556acb0786b4efa975a3c739cd84'

  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}",
                          # "--mandir=#{man}",
                          "--with-boost-python=boost_python-mt"
    system "make install"
  end
end
