require 'formula'

class Varnish <Formula
  url 'http://downloads.sourceforge.net/project/varnish/varnish/2.1.3/varnish-2.1.3.tar.gz'
  homepage 'http://varnish.projects.linpro.no/'
  md5 '357d99a760de173d841ac37bf2052be8'

  depends_on 'pkg-config'
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
