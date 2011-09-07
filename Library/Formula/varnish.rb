require 'formula'

class Varnish < Formula
  url 'http://repo.varnish-cache.org/source/varnish-3.0.1.tar.gz'
  homepage 'http://www.varnish-cache.org/'

  sha1 'f56457c8b7276ed954c5170dac17ba7abd144eb6'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  # Do not strip varnish binaries: Otherwise, the magic string end pointer isn't found.
  skip_clean :all

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
    (var+'varnish').mkpath
  end
end
