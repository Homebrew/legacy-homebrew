require 'formula'

class Owfs <Formula
  head 'cvs://:pserver:anonymous@owfs.cvs.sourceforge.net:/cvsroot/owfs:owfs'
  homepage 'http://owfs.org/'
  md5 ''

  depends_on 'libusb-compat'

  def install
    system "autoreconf -ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
