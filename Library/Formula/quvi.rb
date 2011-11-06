require 'formula'

class Quvi < Formula
  url 'http://sourceforge.net/projects/quvi/files/0.2/quvi-0.2.18.tar.bz2'
  sha1 '42a1a0a949ddb5d3eaec91cddd21ed34a5b1e259'
  homepage 'http://quvi.sourceforge.net/'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'lua'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-smut",
                          "--enable-broken"
    system "make install"
  end
end
