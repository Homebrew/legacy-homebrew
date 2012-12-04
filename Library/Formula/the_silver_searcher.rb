require 'formula'

class TheSilverSearcher < Formula
  homepage 'https://github.com/ggreer/the_silver_searcher'
  url 'https://github.com/downloads/ggreer/the_silver_searcher/the_silver_searcher-0.13.1.tar.gz'
  sha1 '47128b0a19c70b263b0f448e052d6d63443fcadf'

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
