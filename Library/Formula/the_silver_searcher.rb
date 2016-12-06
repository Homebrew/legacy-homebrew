require 'formula'

class TheSilverSearcher < Formula
  homepage 'https://github.com/ggreer/the_silver_searcher'
  url 'https://github.com/downloads/ggreer/the_silver_searcher/the_silver_searcher-0.2.tar.gz'
  md5 'e46f2d5f78623197d8ed996402254708'
  head 'https://github.com/ggreer/the_silver_searcher.git'
  devel do
    head 'https://github.com/packetcollision/the_silver_searcher.git'
  end
  depends_on 'pcre'
  depends_on 'pkg-config' => :build

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
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test the_silver_searcher`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
