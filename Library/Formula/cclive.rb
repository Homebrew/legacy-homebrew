require 'formula'

class Cclive < Formula
  url 'http://cclive.googlecode.com/files/cclive-0.7.9.tar.bz2'
  homepage 'http://cclive.sourceforge.net/'
  sha1 '9e55508f5a98f8dade4b307392fbf0dcebde0633'

  depends_on 'pkg-config' => :build
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
