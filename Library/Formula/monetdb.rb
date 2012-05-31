require 'formula'

class Monetdb < Formula
  url 'http://dev.monetdb.org/downloads/sources/Dec2011/MonetDB-11.7.5.tar.bz2'
  sha1 '67444140c9ef015c7e18bc26faa69f33c1a1220c'
  homepage 'http://www.monetdb.org/'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  depends_on 'pcre'

  # Compilation fails with the libedit library provided by OSX.
  depends_on 'readline'

  def install
    system "./bootstrap" if ARGV.build_head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-debug=no",
                          "--enable-assert=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no"
    system "make install"
  end
end
