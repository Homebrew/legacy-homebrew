require 'formula'

class TheSilverSearcher < Formula
  homepage 'https://github.com/ggreer/the_silver_searcher'
  url 'https://github.com/ggreer/the_silver_searcher/tarball/0.3'
  md5 'd45bf240e3219f9392b5b3cc7a66056c'
  head 'https://github.com/ggreer/the_silver_searcher.git'

  if MacOS.xcode_version >= '4.3'
    depends_on 'automake' => :build
    depends_on 'autoconf' => :build
  end
  depends_on 'pkg-config' => :build
  depends_on 'pcre'


  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal -I /usr/local/share/aclocal"
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
    system "#{bin}/ag --version"
  end
end
