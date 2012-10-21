require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://dev.monetdb.org/downloads/sources/Jul2012-SP2/MonetDB-11.11.11.tar.bz2'
  sha1 'ee053afcfcb2551856f78076eabfb250535d397f'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'readline' # Compilation fails with libedit.

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-debug=no",
                          "--enable-assert=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--disable-jaql",
                          "--without-rubygem"
    system "make install"
  end
end
