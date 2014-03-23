require 'formula'

class Monetdb < Formula
  homepage 'http://www.monetdb.org/'
  url 'http://dev.monetdb.org/downloads/sources/Jan2014-SP1/MonetDB-11.17.13.zip'
  sha1 '51f3fd5a61ffd2bcc85148a3f0bd953a6fc31553'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  option 'with-java'

  depends_on 'pkg-config' => :build
  depends_on :ant
  depends_on 'pcre'
  depends_on 'readline' # Compilation fails with libedit.

  def install
    system "./bootstrap" if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-debug=no",
            "--enable-assert=no",
            "--enable-optimize=yes",
            "--enable-testing=no",
            "--disable-jaql",
            "--without-rubygem"]

    args << "--with-java=no" if build.without? 'java'

    system "./configure", *args
    system "make install"
  end
end
