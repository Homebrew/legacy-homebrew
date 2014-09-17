require 'formula'

class Tinyproxy < Formula
  homepage "https://www.banu.com/tinyproxy/"
  url "https://www.banu.com/pub/tinyproxy/1.8/tinyproxy-1.8.3.tar.bz2"
  sha1 "2538fbd190d3dc357a2e7c2a07ea0fbefb768a13"

  bottle do
    sha1 "edf8eed5ce1ae02bdd09cefba5d3700b6d34c9c9" => :mavericks
    sha1 "17996d138ad31ef834ad23e556afba83ed45c3ef" => :mountain_lion
    sha1 "566f27174a811803b447822407dc33f26d306219" => :lion
  end

  option "reverse", "Enable reverse proxying"
  option "with-transparent", "Enable transparent proxying"

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
    args << "--enable-transparent" if build.with? "transparent"

    system "./configure", *args

    # Fix broken XML lint
    # See: http://www.freebsd.org/cgi/query-pr.cgi?pr=154624
    inreplace ["docs/man5/Makefile", "docs/man8/Makefile"] do |s|
      s.gsub! "-f manpage", "-f manpage \\\n  -L"
    end

    system "make install"
  end
end
