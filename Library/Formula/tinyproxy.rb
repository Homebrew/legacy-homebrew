require 'formula'

class Tinyproxy < Formula
  url 'https://www.banu.com/pub/tinyproxy/1.8/tinyproxy-1.8.3.tar.bz2'
  homepage 'https://www.banu.com/tinyproxy/'
  md5 '292ac51da8ad6ae883d4ebf56908400d'

  skip_clean 'var/run'

  depends_on 'asciidoc' => :build

  # Fix linking error, via MacPorts
  # See: https://trac.macports.org/ticket/27762
  def patches
    {:p0 => [
      "https://trac.macports.org/export/83413/trunk/dports/net/tinyproxy/files/patch-configure.diff"
    ]}
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-regexcheck",
    ]

    # Include reverse proxy support if requested.
    if ARGV.include? '--enable-reverse'
      args << '--enable-reverse'
    end

    system "./configure", *args

    # Fix broken XML lint
    # See: http://www.freebsd.org/cgi/query-pr.cgi?pr=154624
    inreplace ["docs/man5/Makefile", "docs/man8/Makefile"] do |s|
      s.gsub! "-f manpage", "-f manpage \\\n  -L"
    end

    system "make install"
  end

  def options
    [
      ['--enable-reverse', 'Enables reverse proxy support.'],
    ]
  end
end
