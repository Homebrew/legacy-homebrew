require 'formula'

class Owfs < Formula
  url 'http://downloads.sourceforge.net/project/owfs/owfs/2.8p13/owfs-2.8p13.tar.gz'
  version '2.8p13'
  homepage 'http://owfs.org/'
  md5 'cc3e2542aed41c753bffca13f2a0a84e'

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
