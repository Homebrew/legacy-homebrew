require "formula"

class Monetdb < Formula
  homepage "https://www.monetdb.org/"
  url "https://dev.monetdb.org/downloads/sources/Oct2014/MonetDB-11.19.3.zip"
  sha1 "f8290358c1773afc2679d9cbfea456c691f50527"

  bottle do
    sha1 "e5802401b81d035fe81a9a708dd647128a0a4302" => :yosemite
    sha1 "ecefa004cd231e9ad1eef530ae9194f5e3db8c13" => :mavericks
    sha1 "484c94edf77b0acb72aa0e0cb7a8017c149be95c" => :mountain_lion
  end

  head "http://dev.monetdb.org/hg/MonetDB", :using => :hg

  option "with-java"

  depends_on "pkg-config" => :build
  depends_on :ant => :build
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit.
  depends_on "openssl"

  def install
    system "./bootstrap" if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-debug=no",
            "--enable-assert=no",
            "--enable-optimize=yes",
            "--enable-testing=no",
            "--disable-jaql",
            "--without-rubygem"]

    args << "--with-java=no" if build.without? "java"

    system "./configure", *args
    system "make install"
  end
end
