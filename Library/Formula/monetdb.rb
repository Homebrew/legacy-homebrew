require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://www.monetdb.org/downloads/sources/Jan2014/MonetDB-11.17.9.zip'
  sha1 '4669b54fa9a74bba068756ac3902fd8e362a151b'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on :ant
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
