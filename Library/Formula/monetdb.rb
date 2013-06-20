require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://dev.monetdb.org/downloads/sources/Feb2013-SP2/MonetDB-11.15.7.zip'
  sha1 '02a34ffef81f0360cf4c99e06e5e7842a81e3976'

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
