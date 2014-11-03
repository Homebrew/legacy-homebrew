require 'formula'

class Monetdb < Formula
  homepage 'https://www.monetdb.org/'
  url 'https://dev.monetdb.org/downloads/sources/Jan2014-SP3/MonetDB-11.17.21.zip'
  sha1 '53ee8de943ec2a247cf8b2bf645bc0a1b8fd5fc8'

  bottle do
    sha1 "fd10ee968f89f090ed519474aab1b564bc9f54f8" => :mavericks
    sha1 "248f847114fd7658efb1d316ce1324e793bf21a1" => :mountain_lion
    sha1 "c04629aeed599972e59cc5e74c166c52be1dde19" => :lion
  end

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
