require 'formula'

class Mulk < Formula
  url 'http://downloads.sourceforge.net/project/mulk/mulk/mulk%200.6.0/mulk-0.6.0.tar.gz'
  homepage 'http://mulk.sourceforge.net/'
  md5 '4e3311985b56d66548dd99dc2133ba00'

  depends_on 'uriparser' => :build
  depends_on 'libmetalink' => :build

  def install
    gettext = Formula.factory("gettext")
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-nls",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "mulk"
  end
end
