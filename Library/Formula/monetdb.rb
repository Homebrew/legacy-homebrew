require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://www.monetdb.org/downloads/sources/Feb2013-SP5/MonetDB-11.15.17.tar.xz'
  sha1 '8f470b294b65630fefad1b6c7fbdfd814d761056'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'readline' # Compilation fails with libedit.
  depends_on 'xz'

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
