require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
<<<<<<< HEAD
  url 'http://dev.monetdb.org/downloads/sources/Apr2012-SP2/MonetDB-11.9.7.tar.bz2'
  sha1 '50029d88fc1be2fcd54085943120bd9e5aecd2ca'
=======
  url 'http://dev.monetdb.org/downloads/sources/Jul2012/MonetDB-11.11.5.tar.bz2'
  sha1 'f0961abd7f6c467deb4cc540dbfe304f50944ba3'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

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
