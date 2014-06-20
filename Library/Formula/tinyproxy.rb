require 'formula'

class Tinyproxy < Formula
  homepage "https://www.banu.com/tinyproxy/"
  url "https://www.banu.com/pub/tinyproxy/1.8/tinyproxy-1.8.3.tar.bz2"
  sha1 "2538fbd190d3dc357a2e7c2a07ea0fbefb768a13"

  option "reverse", "Enable reverse proxying"

  depends_on "asciidoc" => :build

  # Fix linking error, via MacPorts: https://trac.macports.org/ticket/27762
  patch :p0 do
    url "https://trac.macports.org/export/83413/trunk/dports/net/tinyproxy/files/patch-configure.diff"
    sha1 "e946269b681f3ffaa1acd120c93050cb63bfe743"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-regexcheck
    ]

    args << "--enable-reverse" if build.include? "reverse"

    system "./configure", *args

    # Fix broken XML lint
    # See: http://www.freebsd.org/cgi/query-pr.cgi?pr=154624
    inreplace ["docs/man5/Makefile", "docs/man8/Makefile"] do |s|
      s.gsub! "-f manpage", "-f manpage \\\n  -L"
    end

    system "make install"
  end
end
