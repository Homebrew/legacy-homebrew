require 'formula'

class Varnish <Formula
  url 'http://www.varnish-software.com/sites/default/files/varnish-2.1.4.tar.gz'
  homepage 'http://www.varnish-cache.org/'
  md5 'e794a37b6fbb786a083c0946103ae103'

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

  def patches
    if ARGV.include? '--esis'
      # Adds a helpful vcl variable for accessing esi nest level. See http://varnish-cache.org/trac/ticket/782
      "https://gist.github.com/raw/730589/02a10291c55fef152e7023e9fd1cff8bfe388ef4/varnish-2.1.4-req.esis.patch"
    end
  end

  def options
    [
      ['--esis', 'Add req.esis to vcl. req.esis return esi nest level for request.']
    ]
  end

end
