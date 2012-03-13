require 'formula'

class Openslp < Formula
  url 'http://downloads.sourceforge.net/project/openslp/OpenSLP/1.2.1/openslp-1.2.1.tar.gz'
  homepage 'http://www.openslp.org'
  md5 'ff9999d1b44017281dd00ed2c4d32330'

  def patches
    # patch for adding in missing slp_net symbols
    { :p0 => "https://trac.macports.org/export/78024/trunk/dports/devel/openslp/files/patch-slp_net.txt"}
  end
  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
