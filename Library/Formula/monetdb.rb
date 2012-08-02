require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://dev.monetdb.org/downloads/sources/Apr2012-SP2/MonetDB-11.9.7.tar.bz2'
  sha1 '50029d88fc1be2fcd54085943120bd9e5aecd2ca'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  depends_on 'pcre'
  depends_on 'readline' # Compilation fails with libedit.

  def install
    system "./bootstrap" if ARGV.build_head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-debug=no",
                          "--enable-assert=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--without-rubygem"
    system "make install"
  end
end
