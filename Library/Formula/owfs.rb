require 'formula'

class Owfs <Formula
  url 'http://downloads.sourceforge.net/project/owfs/owfs/2.8p4/owfs-2.8p4.tar.gz'
  version '2.8p4'
  homepage 'http://owfs.org/'
  md5 'beccd8765184b2abea0a3f28dc466ea3'

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
