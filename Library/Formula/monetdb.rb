require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://dev.monetdb.org/downloads/sources/Feb2013-SP3/MonetDB-11.15.11.zip'
  sha1 '12f5a2e65a5a4fa8c67303af5e0b4ea1fe12672b'

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
