require 'formula'

class TheSilverSearcher < Formula
  homepage 'https://github.com/ggreer/the_silver_searcher'
  url 'https://github.com/ggreer/the_silver_searcher/tarball/0.11.1'
  sha1 '73e46e45ad911ef697f53b51764d5306e61b0538'

  head 'https://github.com/ggreer/the_silver_searcher.git'

  depends_on :automake
  depends_on :autoconf

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal -I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake --add-missing"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/ag", "--version"
  end
end
