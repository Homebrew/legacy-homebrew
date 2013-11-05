require 'formula'

class TheSilverSearcher < Formula
  homepage 'https://github.com/ggreer/the_silver_searcher'
  head 'https://github.com/ggreer/the_silver_searcher.git'
  url 'https://github.com/ggreer/the_silver_searcher/archive/0.18.tar.gz'
  sha1 '43c399f5add3921b4fcb7c7f3d21909d81cd0559'

  depends_on :automake
  depends_on :autoconf

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'xz'

  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal -I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake --add-missing"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    bash_completion.install 'ag.bashcomp.sh'
  end

  def test
    system "#{bin}/ag", "--version"
  end
end
