require 'formula'

class Openslp < Formula
  homepage 'http://www.openslp.org'
  url 'http://downloads.sourceforge.net/project/openslp/OpenSLP/1.2.1/openslp-1.2.1.tar.gz'
  sha1 '47ab19154084d2b467f09525f5351e9ab7193cf9'

  def patches
    # patch for adding in missing slp_net symbols
    { :p0 =>
      "https://trac.macports.org/export/78024/trunk/dports/devel/openslp/files/patch-slp_net.txt"
    }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
