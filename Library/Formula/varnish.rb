require 'formula'

class Varnish < Formula
  homepage 'http://www.varnish-cache.org/'
  url 'http://repo.varnish-cache.org/source/varnish-3.0.2.tar.gz'
  sha1 '906f1536cb7e728d18d9425677907ae723943df7'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  # If stripped, the magic string end pointer isn't found.
  skip_clean :all

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
    (var+'varnish').mkpath
  end
end
