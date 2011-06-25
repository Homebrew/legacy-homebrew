require 'formula'

class Varnish < Formula
  url 'http://repo.varnish-cache.org/source/varnish-3.0.0.tar.gz'
  homepage 'http://www.varnish-cache.org/'

  md5 '38387bf31a1574f5cd8dec4f0b7caf20'

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
