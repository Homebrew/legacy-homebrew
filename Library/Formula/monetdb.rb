require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://dev.monetdb.org/downloads/sources/Jul2012/MonetDB-11.11.5.tar.bz2'
  sha1 'f0961abd7f6c467deb4cc540dbfe304f50944ba3'

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
                          "--disable-jaql",
                          "--without-rubygem"
    system "make install"
  end
end
