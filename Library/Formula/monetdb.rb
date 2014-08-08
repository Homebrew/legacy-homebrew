require 'formula'

class Monetdb < Formula
  homepage 'https://www.monetdb.org/'
  url 'https://dev.monetdb.org/downloads/sources/Jan2014-SP3/MonetDB-11.17.21.zip', :using => :ssl3
  sha1 '53ee8de943ec2a247cf8b2bf645bc0a1b8fd5fc8'

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
