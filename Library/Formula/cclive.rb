require 'formula'

class Cclive < Formula
  homepage 'http://cclive.sourceforge.net/'
  url 'http://cclive.googlecode.com/files/cclive-0.7.10.tar.xz'
  sha1 'ca89731073eeda0eb9ccdf3e6cbaca13029f55cb'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'quvi'
  depends_on 'boost'

  # Fix linking against Boost during configure. See:
  # https://trac.macports.org/ticket/29982
  def patches
    {:p0 =>
      "https://trac.macports.org/export/82481/trunk/dports/net/cclive/files/patch-configure.diff"
    }
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
