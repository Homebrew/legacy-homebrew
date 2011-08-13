require 'formula'

class Owfs < Formula
  url 'http://downloads.sourceforge.net/project/owfs/owfs/2.8p9/owfs-2.8p9.tar.gz'
  version '2.8p9'
  homepage 'http://owfs.org/'
  md5 'd0d13d4e4cf9cf52f5261c1c8f0ec5fe'

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
