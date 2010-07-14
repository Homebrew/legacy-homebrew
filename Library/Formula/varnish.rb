require 'formula'

class Varnish <Formula
  url 'http://downloads.sourceforge.net/project/varnish/varnish/2.1.2/varnish-2.1.2.tar.gz'
  homepage 'http://varnish.projects.linpro.no/'
  md5 '8b0d80e47acf4946671c381af55518b9'

  depends_on 'pkg-config'
  depends_on 'pcre'

  def skip_clean? path
    # Do not strip varnish binaries: Otherwise, the magic string end pointer isn't found.
    true
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
    (var+'varnish').mkpath
  end
end