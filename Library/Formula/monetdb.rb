require 'formula'

class Monetdb < Formula
  homepage 'https://www.monetdb.org/'
  url 'https://dev.monetdb.org/downloads/sources/Jan2014-SP2/MonetDB-11.17.17.zip', :using => :ssl3
  sha1 '1f1f668e96a6c38463f6ae7a3821fd05c86a04b3'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  option 'with-java'

  depends_on 'pkg-config' => :build
  depends_on :ant => :build
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
