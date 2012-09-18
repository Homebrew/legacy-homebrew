require 'formula'

class Varnish < Formula
  homepage 'http://www.varnish-cache.org/'
  url 'http://repo.varnish-cache.org/source/varnish-3.0.3.tar.gz'
  sha1 '6e1535caa30c3f61af00160c59d318e470cd6f57'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
    (var+'varnish').mkpath
  end
end
