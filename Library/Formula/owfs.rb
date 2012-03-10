require 'formula'

class Owfs < Formula
  url 'http://downloads.sourceforge.net/project/owfs/owfs/2.8p13/owfs-2.8p13.tar.gz'
  version '2.8p13'
  homepage 'http://owfs.org/'
  md5 'cc3e2542aed41c753bffca13f2a0a84e'

  depends_on 'libusb-compat'

  if MacOS.xcode_version >= "4.3"
    # remove the autoreconf if possible, no comment provided about why it is there
    # so we have no basis to make a decision at this point.
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
