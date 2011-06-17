require 'formula'

class Varnish < Formula
  url 'http://repo.varnish-cache.org/source/varnish-2.1.5.tar.gz'
  head 'http://repo.varnish-cache.org/source/varnish-3.0.0-beta1.tar.gz'
  homepage 'http://www.varnish-cache.org/'

  if ARGV.build_head?
    md5 'c4dbd66ac6795c6c9d1c143ef2a47d38'
  else
    md5 '2d2f227da36a2a240c475304c717b8e3'
  end

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
