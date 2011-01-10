require 'formula'

class Uim <Formula
  url 'http://uim.googlecode.com/files/uim-1.6.0.tar.bz2'
  homepage 'http://code.google.com/p/uim/'
  md5 'cb3b9b2adaff3db9dec43658f30e9f89'

  depends_on 'pkg-config'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
