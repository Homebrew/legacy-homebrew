require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://dev.monetdb.org/downloads/sources/Feb2013-SP1/MonetDB-11.15.3.zip'
  sha1 '2bc2e7bbdfc475c9d195e9d5d36a39757746cb0a'

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
