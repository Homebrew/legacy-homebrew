require 'formula'

class TheSilverSearcher < Formula
  homepage 'https://github.com/ggreer/the_silver_searcher'
  url 'https://github.com/downloads/ggreer/the_silver_searcher/the_silver_searcher-0.2.tar.gz'
  md5 'e46f2d5f78623197d8ed996402254708'
  head 'https://github.com/ggreer/the_silver_searcher.git'

  depends_on 'pcre'
  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build if MacOS.xcode_version >= '4.3'
  depends_on 'autoconf' => :build if MacOS.xcode_version >= '4.3'

  def install
    system "aclocal -I /usr/local/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake --add-missing"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/ag --version"
  end
end
